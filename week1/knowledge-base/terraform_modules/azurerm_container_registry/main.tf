#===========================================================================================================================================#
# Container Registry                                                                                                                        #
#===========================================================================================================================================#

resource "azurerm_container_registry" "acr" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name                          = local.acr_name
  sku                           = "Premium"
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled

  retention_policy_in_days = var.retention_policy_in_days

  data_endpoint_enabled = var.data_endpoint_enabled

  dynamic "identity" {
    for_each = var.identity_type != null ? { identity = true } : {}
    content {
      type         = can(regex("SystemAssigned", var.identity_type)) && can(regex("UserAssigned", var.identity_type)) ? "SystemAssigned, UserAssigned" : can(regex("SystemAssigned", var.identity_type)) ? "SystemAssigned" : can(regex("UserAssigned", var.identity_type)) ? "UserAssigned" : null
      identity_ids = can(regex("UserAssigned", var.identity_type)) || can(regex("SystemAssigned, UserAssigned", var.identity_type)) ? data.azurerm_user_assigned_identity.umids[*].id : null
    }
  }

  dynamic "georeplications" {
    for_each = var.georeplications_configuration
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
    }
  }

  network_rule_set = var.public_network_access_enabled == "false" ? [
    {
      default_action = var.acr_network_rule_set_default_action
      ip_rule = [for each in local.acr_ip_rules :
        {
          action   = each["action"]
          ip_range = each["ip_range"]
        }
      ]
      virtual_network = [for each in local.acr_virtual_network_subnets :
        {
          action    = each["action"]
          subnet_id = each["subnet_id"]
        }
      ]
    }
  ] : []

}

#===========================================================================================================================================#
# Container Registry - Private endpoint                                                                                                     #
#===========================================================================================================================================#

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${azurerm_container_registry.acr.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet[0].id

  private_service_connection {
    name                           = "${azurerm_container_registry.acr.name}-pe-sc"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "privatelink.azurecr.io"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

  depends_on = [azurerm_container_registry.acr]
}

#===========================================================================================================================================#
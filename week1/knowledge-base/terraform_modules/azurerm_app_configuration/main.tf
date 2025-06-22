#-------------------------------------------------------------------------------------------------------------------#
# Prerequisites                                                                                                     #
#-------------------------------------------------------------------------------------------------------------------#
#Random string for cmk key name (Azure policy disallows purging of keys)
resource "random_string" "cmk_suffix" {
  length  = 4
  special = false
  upper   = false
}


# Encryption - KeyVault Key (Customer Managed Key)
resource "azurerm_key_vault_key" "app_config_cmk" {
  name         = local.cmk_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  expiration_date = timeadd(timestamp(), "552600m")

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P365D"
    notify_before_expiry = "P29D"
  }

  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }
}

# RBAC for customer managed key
resource "azurerm_role_assignment" "cmk_umi" {
  for_each             = var.identity_type == "UserAssigned" ? toset(var.app_conf_umids_names) : toset([])
  scope                = azurerm_key_vault_key.app_config_cmk.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = data.azurerm_user_assigned_identity.umids[each.value].principal_id
}

# RBAC for customer managed key
resource "azurerm_role_assignment" "cmk_smi" {
  count                = var.identity_type == "SystemAssigned" ? 1 : 0
  scope                = azurerm_key_vault_key.app_config_cmk.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_app_configuration.appconf.identity[0].principal_id
}

#-------------------------------------------------------------------------------------------------------------------#
# App Configuration                                                                                                 #
#-------------------------------------------------------------------------------------------------------------------#
resource "azurerm_app_configuration" "appconf" {
  name                       = local.app_conf_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  sku                        = var.sku
  local_auth_enabled         = var.local_auth_enabled
  public_network_access      = var.public_network_access
  purge_protection_enabled   = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days

  encryption {
    key_vault_key_identifier = azurerm_key_vault_key.app_config_cmk.id
    identity_client_id       = var.identity_type == "UserAssigned" ? data.azurerm_user_assigned_identity.umids[var.app_conf_umids_names[0]].client_id : null
  }


  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? [for identity in data.azurerm_user_assigned_identity.umids : identity.id] : []
    }
  }

  lifecycle {

    ignore_changes = [tags]

  }

  depends_on = [azurerm_key_vault_key.app_config_cmk, azurerm_role_assignment.cmk_umi]

}

#-------------------------------------------------------------------------------------------------------------------#
# RBACs - App Configuration Data Owner (UMID and DevOps SPI)                                                        #
#-------------------------------------------------------------------------------------------------------------------#

resource "azurerm_role_assignment" "devops_spi" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

#Client identities accessing the app configuration
resource "azurerm_role_assignment" "umid" {
  for_each             = length(var.app_conf_client_access_umids) > 0 ? toset(var.app_conf_client_access_umids) : toset([])
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = each.value
  depends_on           = [azurerm_app_configuration.appconf]
}

#-------------------------------------------------------------------------------------------------------------------#

# Sleep for RBACs to take effect

resource "time_sleep" "rbac_sleep" {
  create_duration = "120s"
  depends_on      = [azurerm_role_assignment.devops_spi]
}

#-------------------------------------------------------------------------------------------------------------------#
# Private endpoint connection for App configuration                                                                 #
#-------------------------------------------------------------------------------------------------------------------#


resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${azurerm_app_configuration.appconf.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet[0].id

  private_service_connection {
    name                           = "${azurerm_app_configuration.appconf.name}-pe-sc"
    private_connection_resource_id = azurerm_app_configuration.appconf.id
    is_manual_connection           = false
    subresource_names              = ["configurationStores"]
  }

  private_dns_zone_group {
    name                 = "privatelink.azconfig.io"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [azurerm_app_configuration.appconf]
}

#-------------------------------------------------------------------------------------------------------------------#
# App configuration key                                                                                             #
#-------------------------------------------------------------------------------------------------------------------#
resource "azurerm_app_configuration_key" "appconf_key" {
  count                  = var.app_conf_key != null ? 1 : 0
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                    = var.app_conf_key
  label                  = var.app_conf_label
  value                  = jsonencode(var.app_conf_value)

  depends_on = [time_sleep.rbac_sleep]
}

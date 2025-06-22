resource "azurerm_service_plan" "azure_serviceplan" {
  name                = local.serviceplan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.service_plan_os_type
  sku_name            = var.service_plan_sku_name
}

resource "azurerm_logic_app_standard" "logicapp" {
  for_each = { for n in var.logic_app : n.logic_app_description => n }
  name     = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-logicapp-${each.value.logic_app_description}")

  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.azure_serviceplan.id
  storage_account_name       = var.logic_app_storage_account_name
  storage_account_access_key = var.logic_app_storage_account_key ### this field in mandatory, current policies does not allow this auth method in SA. Freezing module development
  https_only                 = true
  virtual_network_subnet_id  = var.virtual_network_subnet_id

  lifecycle {
    ignore_changes = [app_settings, tags]
  }

  #site_config {
  #  public_network_access_enabled = false
  #}
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~16"
  }


  dynamic "identity" {
    for_each = each.value.requires_identity == true ? [1] : []
    content {
      identity_ids = var.user_managed_identities
      type         = "UserAssigned"
    }
  }

  dynamic "identity" {
    for_each = each.value.requires_identity == false ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

}


resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = azurerm_logic_app_standard.logicapp
  name                = lower("${each.value.name}-pe")
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.vnet_pe_id

  private_service_connection {
    name                           = lower("${each.value.name}-pe-sc")
    private_connection_resource_id = each.value.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

   lifecycle {
    ignore_changes = [tags]
  }
}
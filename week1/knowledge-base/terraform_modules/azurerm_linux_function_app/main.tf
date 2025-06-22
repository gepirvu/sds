## App Service Plan

resource "azurerm_service_plan" "app_service_function_app" {
  name                   = local.app_service_plan_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  os_type                = "Linux"
  sku_name               = var.sku_name
  zone_balancing_enabled = var.zone_balancing_enabled
  worker_count           = var.worker_count
}

## Function App

resource "azurerm_linux_function_app" "function_app" {
  for_each            = { for config in var.function_app : config.usecase => config }
  name                = "${local.function_app_name}-${each.value.usecase}"
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name          = data.azurerm_storage_account.storage_account.name
  storage_uses_managed_identity = true
  service_plan_id               = azurerm_service_plan.app_service_function_app.id
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = data.azurerm_subnet.vint_subnet.id

  site_config {}
}

## Private Endpoint

# Create private based on the storage type
resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = { for config in var.function_app : config.usecase => config }
  name                = "${azurerm_linux_function_app.function_app[each.value.usecase].name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "${azurerm_linux_function_app.function_app[each.value.usecase].name}-pe-sc"
    private_connection_resource_id = azurerm_linux_function_app.function_app[each.value.usecase].id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }
}
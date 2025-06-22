module "windows_function_apps" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_windows_function_app?ref=~{gitRef}~"

  # General

  resource_group_name = var.resource_group_name
  location            = var.location

  # Naming Convention

  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment

  # App Service Plan

  sku_name               = var.sku_name
  zone_balancing_enabled = var.zone_balancing_enabled
  worker_count           = var.worker_count

  # Function Apps

  function_app                        = var.function_app
  storage_account_name                = var.storage_account_name
  storage_account_resource_group_name = var.storage_account_resource_group_name
  https_only                          = var.https_only
  vnet_integration_subnet_name        = var.vnet_integration_subnet_name
  public_network_access_enabled       = var.public_network_access_enabled

  # Private Endpoint

  pe_subnet_name              = var.pe_subnet_name
  network_name                = var.network_name
  network_resource_group_name = var.network_resource_group_name
}
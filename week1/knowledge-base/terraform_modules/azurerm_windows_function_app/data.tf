# Purpose: Define the data sources to fetch and use information from external sources or existing resources to configure your infrastructure.
data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.storage_account_resource_group_name
}

data "azurerm_subnet" "pe_subnet" {
  name                 = var.pe_subnet_name
  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}

data "azurerm_subnet" "vint_subnet" {
  name                 = var.vnet_integration_subnet_name
  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}
data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  resource_group_name = var.virtual_network_resource_group_name
}

data "azurerm_subnet" "pe_subnet" {
  name                 = var.pe_subnet_name
  virtual_network_name = data.azurerm_virtual_network.virtual_network.name
  resource_group_name  = var.virtual_network_resource_group_name
}


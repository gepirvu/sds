
data "azurerm_subnet" "pe_subnet" {
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
  name                 = var.pe_subnet_name
}

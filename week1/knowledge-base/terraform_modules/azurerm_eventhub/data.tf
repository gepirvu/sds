# Get the subnet ID for the private endpoint
data "azurerm_subnet" "eventhub_pe_subnet" {
  name                 = var.pe_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
}
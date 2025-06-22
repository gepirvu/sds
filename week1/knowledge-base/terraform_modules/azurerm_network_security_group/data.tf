data "azurerm_subnet" "subnet" {
  for_each             = { for each in var.nsgs : each.subnet_name => each if each.associate_to_subnet == true }
  name                 = each.value.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}
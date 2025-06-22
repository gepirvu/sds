data "azurerm_subnet" "pe_subnets" {
  name                 = var.pe_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name

}

#----------------------------------------------------------------------------------------------------------------#
# User assigned managed identity information                                                                     #
#----------------------------------------------------------------------------------------------------------------#

data "azurerm_user_assigned_identity" "umids" {
  for_each            = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned,UserAssigned" ? toset(var.umids_names) : toset([])
  name                = each.value
  resource_group_name = var.resource_group_name

}
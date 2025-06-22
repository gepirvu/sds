# Get the subnet ID for the private endpoint for Storage Account
data "azurerm_subnet" "sa_subnet" {
  name                 = var.sa_subnet_name
  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "umids" {
  for_each            = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned,UserAssigned" ? toset(var.umids_names) : toset([])
  name                = each.value
  resource_group_name = var.resource_group_name

}

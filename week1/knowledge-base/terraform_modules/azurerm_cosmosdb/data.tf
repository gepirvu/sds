data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azuread_service_principal" "cosmos_db" {
  display_name = "Azure Cosmos DB"
}

data "azurerm_user_assigned_identity" "umids" {
  for_each            = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned,UserAssigned" ? toset(var.umids_names) : toset([])
  name                = each.value
  resource_group_name = var.resource_group_name

}

data "azurerm_subnet" "pe_subnets" {
  name                 = var.pe_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name

}

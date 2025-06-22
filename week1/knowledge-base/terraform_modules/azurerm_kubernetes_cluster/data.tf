data "azurerm_client_config" "current" {
}

data "azuread_group" "azuread_group_readers" {
  count            = length(var.azuread_group_readers_names)
  display_name     = var.azuread_group_readers_names[count.index]
  security_enabled = true
}

data "azuread_group" "azuread_group_admin" {
  count            = length(var.azuread_group_admin_names)
  display_name     = var.azuread_group_admin_names[count.index]
  security_enabled = true
}

data "azurerm_virtual_network" "aks_vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.network_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name

}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name

}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.aks_loga_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "user_assigned_identity" {
  for_each            = { for each in var.workload_assigned_identities : each.workload_assigned_identity_name => each if each.workload_assigned_identity_exists == true }
  name                = each.value.workload_assigned_identity_name
  resource_group_name = var.resource_group_name
}

#RBAC for namespaces

data "azuread_group" "group_objects_writer" {
  for_each     = { for policy in toset(local.role_group_combinations_writer) : "${policy.namespace}-${policy.group_name}" => policy if policy.group_name != null }
  display_name = each.value.group_name
}

data "azuread_group" "group_objects_reader" {
  for_each     = { for policy in toset(local.role_group_combinations_reader) : "${policy.namespace}-${policy.group_name}" => policy if policy.group_name != null }
  display_name = each.value.group_name
}
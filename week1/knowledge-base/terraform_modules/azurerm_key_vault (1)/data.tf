data "azurerm_client_config" "current_config" {
}

data "azuread_group" "rbac_keyvault_administrator" {
  for_each         = toset(var.admin_groups)
  display_name     = each.value
  security_enabled = true
}

data "azuread_group" "rbac_keyvault_reader" {
  for_each         = toset(var.reader_groups)
  display_name     = each.value
  security_enabled = true
}

# Get the subnet ID for the private endpoint
data "azurerm_subnet" "sa_subnet" {
  name                 = var.pe_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
}

# Get the loga id for diagnostic settings
data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
}

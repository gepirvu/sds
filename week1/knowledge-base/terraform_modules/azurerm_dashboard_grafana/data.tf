data "azurerm_monitor_workspace" "monitor_workspace" {
  count               = var.azure_monitor_workspace_name != null && var.azure_monitor_workspace_enabled == true ? 1 : 0
  name                = var.azure_monitor_workspace_name
  resource_group_name = var.resource_group_name
}

# Get the subnet ID for the private endpoint
data "azurerm_subnet" "subnet" {
  name                 = var.pe_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
}

data "azuread_group" "rbac_grafana_administrator" {
  for_each         = length(var.admin_groups) > 0 ? toset(var.admin_groups) : []
  display_name     = each.value
  security_enabled = true
}

data "azuread_group" "rbac_grafana_editor" {
  for_each         = length(var.editor_groups) > 0 ? toset(var.editor_groups) : []
  display_name     = each.value
  security_enabled = true
}

data "azuread_group" "rbac_grafana_viewer" {
  for_each         = length(var.viewer_groups) > 0 ? toset(var.viewer_groups) : []
  display_name     = each.value
  security_enabled = true
}
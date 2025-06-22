resource "azurerm_role_assignment" "rbac_grafana_administrator" {
  for_each             = length(var.admin_groups) > 0 ? toset(var.admin_groups) : []
  scope                = azurerm_dashboard_grafana.dashboard_grafana.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azuread_group.rbac_grafana_administrator[each.key].object_id
}

resource "azurerm_role_assignment" "rbac_grafana_editor" {
  for_each             = length(var.editor_groups) > 0 ? toset(var.editor_groups) : []
  scope                = azurerm_dashboard_grafana.dashboard_grafana.id
  role_definition_name = "Grafana Editor"
  principal_id         = data.azuread_group.rbac_grafana_editor[each.key].object_id
}

resource "azurerm_role_assignment" "rbac_grafana_viewer" {
  for_each             = length(var.viewer_groups) > 0 ? toset(var.viewer_groups) : []
  scope                = azurerm_dashboard_grafana.dashboard_grafana.id
  role_definition_name = "Grafana Viewer"
  principal_id         = data.azuread_group.rbac_grafana_viewer[each.key].object_id
}


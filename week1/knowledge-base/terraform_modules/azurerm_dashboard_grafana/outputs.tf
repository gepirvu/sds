output "azurerm_monitor_workspace_name" {
  value = azurerm_monitor_workspace.monitor_workspace[0].name

}
output "azurerm_monitor_workspace_id" {
  value = azurerm_monitor_workspace.monitor_workspace[0].id

}
output "azurerm_dashboard_grafana_name" {
  value = azurerm_dashboard_grafana.dashboard_grafana.name

}
output "azurerm_dashboard_grafana_id" {
  value = azurerm_dashboard_grafana.dashboard_grafana.id

}
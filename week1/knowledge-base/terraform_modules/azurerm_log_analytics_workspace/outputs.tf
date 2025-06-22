output "laws_id" {
  description = "value of the Log analytics workspace id"
  value       = azurerm_log_analytics_workspace.law.*.id
}

output "laws_name" {
  description = "value of the Log analytics workspace name"
  value       = azurerm_log_analytics_workspace.law.*.name
}
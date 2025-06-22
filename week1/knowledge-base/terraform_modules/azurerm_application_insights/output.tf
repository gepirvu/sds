output "instrumentation_key" {
  description = "value of the app insights instrumentation key"
  value       = azurerm_application_insights.arm_app_insights.instrumentation_key
}

output "connection_string" {
  description = "value of the app insights connection string"
  value       = azurerm_application_insights.arm_app_insights.connection_string
}

output "app_insights_id" {
  description = "value of the app insights id"
  value       = azurerm_application_insights.arm_app_insights.id
}

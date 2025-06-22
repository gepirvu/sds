output "app_config_id" {
  value       = azurerm_app_configuration.appconf.id
  description = "The App Configuration ID."
}

output "app_config_endpoint" {
  value       = azurerm_app_configuration.appconf.endpoint
  description = "The URL of the App Configuration."
}

// output "app_conf_managed_identity" {
//   value       = azurerm_app_configuration.appconf.identity.0.principal_id
//   description = "The Principal ID associated with this Managed Service Identity."
// }

# Local access keys are disabled by default. To enable them, set the local_auth_enabled property to true.

# output "app_conf_primary_read_connection_string" {
#   value       = azurerm_app_configuration.appconf.primary_read_key.0.connection_string
#   description = "The Connection String for this Access Key - comprising of the Endpoint, ID and Secret."
# }

# output "app_conf_primary_write_connection_string" {
#   value       = azurerm_app_configuration.appconf.primary_write_key.0.connection_string
#   description = "The Connection String for this Access Key - comprising of the Endpoint, ID and Secret."
# }
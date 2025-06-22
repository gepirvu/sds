output "name" {
  value       = azurerm_container_app_environment.cae.name
  description = "The name of the Container App Environment"
}

output "id" {
  value       = azurerm_container_app_environment.cae.id
  description = "The ID of the Container App Environment"
}

output "container_app_environment_static_ip_address" {
  value = azurerm_container_app_environment.cae.static_ip_address
}

output "container_app_custom_domains" {
  value = var.ca_custom_domains != null ? [
    for ca_custom_domains in var.ca_custom_domains : ca_custom_domains.ca_custom_domain_name
  ] : []
}


# PostgreSQL flexible server ID

output "id" {
  value       = azurerm_postgresql_flexible_server.pgsqlflexible_server.id
  description = "The ID of the PostgreSQL Flexible Server."
}

# PostgreSQL flexible server name

output "name" {
  value       = azurerm_postgresql_flexible_server.pgsqlflexible_server.name
  description = "The name of the PostgreSQL Flexible Server."
}

# PostgreSQL flexible server fully qualified domain name

output "fqdn" {
  value       = azurerm_postgresql_flexible_server.pgsqlflexible_server.fqdn
  description = "The fully qualified domain name of the PostgreSQL Flexible Server."
}

# PostgreSQL flexible server public network access enabled

output "public_network_access_enabled" {
  value       = azurerm_postgresql_flexible_server.pgsqlflexible_server.public_network_access_enabled
  description = "Whether or not public network access is allowed for this PostgreSQL Flexible Server."
}
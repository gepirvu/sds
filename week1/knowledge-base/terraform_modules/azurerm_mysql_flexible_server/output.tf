output "mysql_flexible_databases" {
  description = "Map of databases infos"
  value       = azurerm_mysql_flexible_database.mysql_flexible_db
}

output "mysql_flexible_databases_names" {
  description = "List of databases names"
  value       = [for db in azurerm_mysql_flexible_database.mysql_flexible_db : db.name]
}

output "mysql_flexible_database_ids" {
  description = "The list of all database resource IDs"
  value       = [for db in azurerm_mysql_flexible_database.mysql_flexible_db : db.id]
}

output "mysql_flexible_firewall_rule_ids" {
  description = "Map of MySQL created firewall rules"
  value       = azurerm_mysql_flexible_server_firewall_rule.firewall_rules
}

output "mysql_flexible_fqdn" {
  description = "FQDN of the MySQL server"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.fqdn
}

output "mysql_flexible_server_id" {
  description = "MySQL server ID"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.id
}

output "mysql_flexible_server_name" {
  description = "MySQL server name"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.name
}
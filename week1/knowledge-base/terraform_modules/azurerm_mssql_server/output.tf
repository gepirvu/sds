output "mssql_server_name" {
  value       = azurerm_mssql_server.mssql_server.name
  description = "value of the mssql server name"
}

output "mssql_server_id" {
  value       = azurerm_mssql_server.mssql_server.id
  description = "value of the mssql server id"
}

output "fully_qualified_domain_name" {
  value       = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
  description = "value of the mssql server fully qualified domain name"
}

output "msssql_elastic_pool_name" {
  value       = var.elastic_pool_config.name
  description = "value of the mssql elastic pool name"
}

output "msssql_elastic_pool_id" {
  value       = var.create_elastic_pool ? azurerm_mssql_elasticpool.msssql_elastic_pool[0].id : null
  description = "value of the mssql elastic pool id"
}
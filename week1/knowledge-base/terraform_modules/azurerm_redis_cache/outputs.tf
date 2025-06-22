output "name" {
  value       = azurerm_redis_cache.redis_cache.name
  description = "The name of the Redis."
}

output "id" {
  value       = azurerm_redis_cache.redis_cache.id
  description = "The ID of the Redis."
}
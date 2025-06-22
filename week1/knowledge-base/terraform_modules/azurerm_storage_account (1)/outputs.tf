output "storage_account_id" {
  description = "value of the storage account id"
  value       = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  description = "value of the storage account name"
  value       = azurerm_storage_account.storage_account.name
}

output "container_names" {
  value       = [for each in azurerm_storage_container.storage_container : each.name]
  description = "The list of container Names"
}

output "container_ids" {
  value       = [for each in azurerm_storage_container.storage_container : each.id]
  description = "The list of container IDs"
}

output "resource_manager_ids" {
  value       = [for each in azurerm_storage_container.storage_container : each.resource_manager_id]
  description = "The list of container resource manager IDs"
}
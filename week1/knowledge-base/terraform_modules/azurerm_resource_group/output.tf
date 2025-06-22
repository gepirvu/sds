output "resource_group_name" {
  description = "value of the resource group name"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
  description = "value of the resource group id"
  value       = azurerm_resource_group.resource_group.id
}

output "uid_id" {
  description = "User Managed Identity ID"
  value       = [for id in azurerm_user_assigned_identity.user_id : id.client_id]
}

output "uid_principal_id" {
  description = "User Managed Identity ID"
  value       = [for id in azurerm_user_assigned_identity.user_id : id.principal_id]

}

output "uid_client_id" {
  description = "User Managed Identity Client ID"
  value       = [for id in azurerm_user_assigned_identity.user_id : id.client_id]
}

output "tenant_id" {
  description = "User Managed Identity Tenant ID"
  value       = [for id in azurerm_user_assigned_identity.user_id : id.tenant_id]
}

output "uid_name" {
  description = "User Managed Identity Tenant ID"
  value       = [for id in azurerm_user_assigned_identity.user_id : id.name]
}
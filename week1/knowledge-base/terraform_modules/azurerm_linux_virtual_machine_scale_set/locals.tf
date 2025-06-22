locals {
  linux_vmss_name      = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.usecase}-linux-vmss")
  linux_vmss_subnet_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.vmss_subnet.vnet_rg_name}/providers/Microsoft.Network/virtualNetworks/${var.vmss_subnet.vnet_name}/subnets/${var.vmss_subnet.subnet_name}"

  key_vault_id             = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.keyvault_details.kv_rg_name}/providers/Microsoft.KeyVault/vaults/${var.keyvault_details.kv_name}"
  disk_encryption_set_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.usecase}-linux-vmss-des")
  disk_encryption_key_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.usecase}-${random_string.string.result}-key")

  managed_identity_ids = var.identity_type != null ? [
    for identity in var.managed_identities : "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${identity.resource_group_name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${identity.name}"
  ] : null
}

locals {
  days_to_hours = 365 * 24
  // expiration date need to be in a specific format as well
  expiration_date = timeadd(formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp()), "${local.days_to_hours}h")
}
# Naming
locals {
  mysql_flexible_server_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-mysqldb")
  administrator_password     = coalesce(var.administrator_password, random_password.mysql_administrator_password.result)
}

#MySQL Configuration
locals {
  default_mysql_options = {
    require_secure_transport = var.ssl_enforced ? "ON" : "OFF"
  }
}

#Resources Ids
locals {
  user_assigned_identity_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.user_assigned_identity_name}"
  private_dns_zone_id       = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.mysql.database.azure.com"
  delegated_subnet_id       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.delegated_subnet_details.vnet_rg_name}/providers/Microsoft.Network/virtualNetworks/${var.delegated_subnet_details.vnet_name}/subnets/${var.delegated_subnet_details.subnet_name}"
  key_vault_id              = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.key_vault_name}"
}

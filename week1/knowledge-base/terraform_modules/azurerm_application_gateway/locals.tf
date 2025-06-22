locals {
  # Resources naming
  application_gateway_name    = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-appgw")
  user_assigned_identity_name = lower("axso-${var.subscription}-${var.project_name}-${var.environment}-appgw-umid")
  public_ip_name              = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-appgw-pip")
}
locals {
  # Appgw naming
  frontend_port_name             = "${local.application_gateway_name}-feport"
  frontend_ip_configuration_name = "${local.application_gateway_name}-feip"
}

locals {
  azurerm_subnet_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.virtual_network_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.vnet_name}/subnets/${var.subnet_name}"
  key_vault_id      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.key_vault_name}"
}



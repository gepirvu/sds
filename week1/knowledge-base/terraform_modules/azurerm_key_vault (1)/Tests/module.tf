
# Create Key Vault:
module "axso_key_vault" {
  source                          = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_key_vault?ref=~{gitRef}~"
  project_name                    = var.project_name
  environment                     = var.environment
  kv_number                       = var.kv_number
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku_name                        = var.sku_name
  soft_delete_retention_days      = var.soft_delete_retention_days
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  admin_groups                    = var.admin_groups
  reader_groups                   = var.reader_groups
  public_network_access_enabled   = var.public_network_access_enabled
  network_acls                    = var.network_acls
  network_resource_group_name     = var.network_resource_group_name
  virtual_network_name            = var.virtual_network_name
  pe_subnet_name                  = var.pe_subnet_name
  log_analytics_workspace_name    = var.log_analytics_workspace_name
  expire_notification             = var.expire_notification
  email_receiver                  = var.email_receiver
}
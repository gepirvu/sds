# App configuration

module "axso_app_config" {
  source   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_app_configuration?ref=~{gitRef}~"
  for_each = { for each in var.app_conf : each.environment => each }

  resource_group_name        = var.resource_group_name
  location                   = var.location
  key_vault_name             = var.key_vault_name
  project_name               = each.value.project_name
  subscription               = each.value.subscription
  environment                = each.value.environment
  sku                        = each.value.sku
  local_auth_enabled         = each.value.local_auth_enabled
  purge_protection_enabled   = each.value.purge_protection_enabled
  soft_delete_retention_days = each.value.soft_delete_retention_days
  identity_type              = each.value.identity_type
  pe_subnet                  = each.value.pe_subnet
  public_network_access      = each.value.public_network_access

  # App config key
  app_conf_key                 = each.value.app_conf_key
  app_conf_label               = each.value.app_conf_label
  app_conf_value               = each.value.app_conf_value
  app_conf_umids_names         = var.app_conf_umids_names
  app_conf_client_access_umids = var.app_conf_client_access_umids
}

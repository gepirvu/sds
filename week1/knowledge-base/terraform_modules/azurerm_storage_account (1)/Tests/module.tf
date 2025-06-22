module "axso_storage_account" {
  for_each                         = { for each in var.storage_accounts : each.storage_account_index => each }
  source                           = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_storage_account?ref=~{gitRef}~"
  location                         = var.location
  subscription                     = var.subscription
  environment                      = var.environment
  project_name                     = var.project_name
  resource_group_name              = var.resource_group_name
  key_vault_name                   = var.key_vault_name
  storage_account_index            = each.value.storage_account_index
  account_tier_storage             = each.value.account_tier_storage
  access_tier_storage              = each.value.access_tier_storage
  account_replication_type_storage = each.value.account_replication_type_storage
  account_kind_storage             = each.value.account_kind_storage
  public_network_access_enabled    = each.value.public_network_access_enabled
  net_rules                        = each.value.network_acl
  nfsv3_enabled                    = each.value.nfsv3_enabled
  is_hns_enabled                   = each.value.is_hns_enabled
  network_name                     = each.value.network_name
  sa_subnet_name                   = each.value.sa_subnet_name
  network_resource_group_name      = each.value.network_resource_group_name
  delete_retention_policy_days     = each.value.delete_retention_policy_days
  container_names                  = each.value.container_names
  identity_type                    = each.value.identity_type
  umids_names                      = each.value.umids_names
}
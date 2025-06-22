
module "data_protection_backup_vault" {
  source                                    = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_data_protection_backup?ref=~{gitRef}~" # update v0.0.0 with the latest version
  subscription                              = var.subscription
  project_name                              = var.project_name
  environment                               = var.environment
  location                                  = var.location
  resource_group_name                       = var.resource_group_name
  datastore_type                            = var.datastore_type
  redundancy                                = var.redundancy
  cross_region_restore_enabled              = var.cross_region_restore_enabled
  retention_duration_in_days                = var.retention_duration_in_days
  soft_delete                               = var.soft_delete
  snapshot_resource_group_id                = var.snapshot_resource_group_id
  blob_storage_backup_config                = var.blob_storage_backup_config
  blob_storage_backup_policy                = var.blob_storage_backup_policy
  managed_disk_backup_config                = var.managed_disk_backup_config
  managed_disk_backup_policy                = var.managed_disk_backup_policy
  kubernetes_cluster_backup_policy          = var.kubernetes_cluster_backup_policy
  kubernetes_cluster_backup_config          = var.kubernetes_cluster_backup_config
  kubernetes_cluster_storage_account_config = var.kubernetes_cluster_storage_account_config
  psql_flexible_server_backup_policy        = var.psql_flexible_server_backup_policy
  psql_flexible_server_backup_config        = var.psql_flexible_server_backup_config
}


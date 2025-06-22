# Purpose: To defining the local values to use in the configuration such as naming conventions, private endpoints, etc.
locals {
  data_protection_backup_vault_name          = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-dpb")
  data_protection_backup_policy_blob_storage = "blob-policy"
  data_protection_backup_policy_disk         = "disk-policy"
  data_protection_backup_policy_aks          = "aks-policy"
  data_protection_backup_policy_psql         = "psql-policy"
  data_protection_backup_policy_mysql        = "mysql-policy"

  snapshot_resource_group_name = element(regex("resourceGroups/([^/]+)$", var.snapshot_resource_group_id), 0)
  snapshot_subscription_id     = element(regex("subscriptions/([^/]+)", var.snapshot_resource_group_id), 0)


}



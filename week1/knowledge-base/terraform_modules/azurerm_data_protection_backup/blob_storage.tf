# Blob Storage Backup

resource "azurerm_role_assignment" "role_assignment_sa" {
  for_each             = { for idx, storage_account in var.blob_storage_backup_config : storage_account.storage_account_name => storage_account }
  scope                = data.azurerm_storage_account.storage_account[each.value.storage_account_name].id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.identity[0].principal_id
}

resource "azurerm_data_protection_backup_policy_blob_storage" "data_protection_backup_policy_blob_storage" {
  for_each                               = { for idx, storage_backup_policy in var.blob_storage_backup_policy : storage_backup_policy.blob_storage_backup_policy_name => storage_backup_policy }
  name                                   = "${local.data_protection_backup_policy_blob_storage}-${each.value.blob_storage_backup_policy_name}"
  vault_id                               = azurerm_data_protection_backup_vault.data_protection_backup_vault.id
  backup_repeating_time_intervals        = each.value.vault_default_retention_duration != null ? each.value.backup_repeating_time_intervals : null
  operational_default_retention_duration = each.value.operational_default_retention_duration
  vault_default_retention_duration       = each.value.vault_default_retention_duration

  dynamic "retention_rule" {
    for_each = each.value.retention_rule != null ? each.value.retention_rule : []
    content {
      name     = retention_rule.value.name
      priority = retention_rule.value.priority
      criteria {
        absolute_criteria      = retention_rule.value.criteria.absolute_criteria
        days_of_month          = retention_rule.value.criteria.days_of_month
        days_of_week           = retention_rule.value.criteria.days_of_week
        weeks_of_month         = retention_rule.value.criteria.weeks_of_month
        months_of_year         = retention_rule.value.criteria.months_of_year
        scheduled_backup_times = retention_rule.value.criteria.scheduled_backup_times
      }
      life_cycle {
        data_store_type = retention_rule.value.lifecycle.data_store_type
        duration        = retention_rule.value.lifecycle.duration
      }
    }

  }
}

resource "azurerm_data_protection_backup_instance_blob_storage" "data_protection_backup_instance_blob_storage" {
  for_each                        = { for idx, storage_account in var.blob_storage_backup_config : storage_account.storage_account_name => storage_account }
  name                            = each.value.storage_account_name
  vault_id                        = azurerm_data_protection_backup_vault.data_protection_backup_vault.id
  location                        = var.location
  storage_account_id              = data.azurerm_storage_account.storage_account[each.value.storage_account_name].id
  backup_policy_id                = azurerm_data_protection_backup_policy_blob_storage.data_protection_backup_policy_blob_storage[each.value.blob_storage_backup_policy_name].id
  storage_account_container_names = each.value.storage_account_container_names

  depends_on = [azurerm_role_assignment.role_assignment_sa]
}
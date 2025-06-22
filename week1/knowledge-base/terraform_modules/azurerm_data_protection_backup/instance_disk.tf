# Azure Disk Backup


resource "azurerm_role_assignment" "role_assignment_disk_reader" {
  for_each             = { for idx, managed_disk in var.managed_disk_backup_config : managed_disk.disk_name => managed_disk }
  scope                = data.azurerm_managed_disk.managed_disk[each.value.disk_name].id
  role_definition_name = "Disk Backup Reader"
  principal_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.identity[0].principal_id
}

resource "azurerm_data_protection_backup_policy_disk" "data_protection_backup_policy_disk" {
  for_each                        = { for idx, managed_disk_backup_policy in var.managed_disk_backup_policy : managed_disk_backup_policy.managed_disk_backup_policy_name => managed_disk_backup_policy }
  name                            = "${local.data_protection_backup_policy_disk}-${each.value.managed_disk_backup_policy_name}"
  vault_id                        = azurerm_data_protection_backup_vault.data_protection_backup_vault.id
  default_retention_duration      = each.value.default_retention_duration
  backup_repeating_time_intervals = each.value.backup_repeating_time_intervals
  time_zone                       = each.value.time_zone

  dynamic "retention_rule" {
    for_each = each.value.retention_rule != null ? each.value.retention_rule : []
    content {
      name     = retention_rule.value.name
      duration = retention_rule.value.duration
      priority = retention_rule.value.priority
      criteria {
        absolute_criteria = retention_rule.value.criteria.absolute_criteria
      }
    }

  }
}

resource "azurerm_data_protection_backup_instance_disk" "data_protection_backup_instance_disk" {
  for_each                     = { for idx, managed_disk in var.managed_disk_backup_config : managed_disk.disk_name => managed_disk }
  name                         = each.value.disk_name
  vault_id                     = azurerm_data_protection_backup_vault.data_protection_backup_vault.id
  location                     = var.location
  disk_id                      = data.azurerm_managed_disk.managed_disk[each.value.disk_name].id
  snapshot_resource_group_name = local.snapshot_resource_group_name
  backup_policy_id             = azurerm_data_protection_backup_policy_disk.data_protection_backup_policy_disk[each.value.managed_disk_backup_policy_name].id

  depends_on = [azurerm_role_assignment.role_assignment_disk_reader, azurerm_role_assignment.role_assignment_disk_snapshot_contributor]
}


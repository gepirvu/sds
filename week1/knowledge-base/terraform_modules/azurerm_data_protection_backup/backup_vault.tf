resource "azurerm_data_protection_backup_vault" "data_protection_backup_vault" {
  name                         = local.data_protection_backup_vault_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  datastore_type               = var.datastore_type
  redundancy                   = var.redundancy
  cross_region_restore_enabled = var.redundancy == "GeoRedundant" ? var.cross_region_restore_enabled : null
  retention_duration_in_days   = var.retention_duration_in_days
  soft_delete                  = var.soft_delete

  identity {
    type = "SystemAssigned"
  }


  lifecycle {
    ignore_changes = [tags]
  }
  depends_on = [time_sleep.wait_30_seconds_container]
}

#Common RBAC

resource "azurerm_role_assignment" "role_assignment_disk_snapshot_contributor" {
  count                = length(var.managed_disk_backup_config) > 0 || length(var.kubernetes_cluster_backup_config) > 0 ? 1 : 0
  scope                = var.snapshot_resource_group_id
  role_definition_name = "Disk Snapshot Contributor"
  principal_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "vault_reader_on_snap_rg" {
  scope                = var.snapshot_resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.identity[0].principal_id
}

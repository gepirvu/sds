# Aks Backup

#Create blob storage in case is nedeed

resource "azurerm_storage_container" "storage_container" {
  count                 = coalesce(var.kubernetes_cluster_storage_account_config.create_cluster_backup_storage_account_blob, false) ? 1 : 0
  name                  = var.kubernetes_cluster_storage_account_config.kubernetes_cluster_backup_storage_account_blob_name
  storage_account_id    = data.azurerm_storage_account.storage_account_aks[0].id
  container_access_type = "private"

}

resource "time_sleep" "wait_30_seconds_container" {
  depends_on = [azurerm_storage_container.storage_container]

  destroy_duration = "30s"
}



resource "azurerm_data_protection_backup_policy_kubernetes_cluster" "data_protection_backup_policy_kubernetes_cluster" {
  for_each                        = { for idx, kubernetes_cluster_backup_policy in var.kubernetes_cluster_backup_policy : kubernetes_cluster_backup_policy.kubernetes_cluster_backup_policy_name => kubernetes_cluster_backup_policy }
  name                            = "${local.data_protection_backup_policy_aks}-${each.value.kubernetes_cluster_backup_policy_name}"
  resource_group_name             = var.resource_group_name
  vault_name                      = azurerm_data_protection_backup_vault.data_protection_backup_vault.name
  backup_repeating_time_intervals = each.value.backup_repeating_time_intervals != null ? each.value.backup_repeating_time_intervals : null
  time_zone                       = each.value.time_zone

  dynamic "retention_rule" {
    for_each = each.value.retention_rule != null ? each.value.retention_rule : []
    content {
      name     = retention_rule.value.name
      priority = retention_rule.value.priority
      criteria {
        absolute_criteria      = retention_rule.value.criteria.absolute_criteria
        days_of_week           = retention_rule.value.criteria.days_of_week
        weeks_of_month         = retention_rule.value.criteria.weeks_of_month
        months_of_year         = retention_rule.value.criteria.months_of_year
        scheduled_backup_times = retention_rule.value.criteria.scheduled_backup_times
      }
      life_cycle {
        data_store_type = "OperationalStore"
        duration        = retention_rule.value.lifecycle.duration
      }
    }

  }
  dynamic "default_retention_rule" {
    for_each = each.value.default_retention_rule != null ? each.value.default_retention_rule : {}
    content {
      life_cycle {
        data_store_type = "OperationalStore"
        duration        = default_retention_rule.value.duration
      }
    }

  }

}

resource "azurerm_kubernetes_cluster_trusted_access_role_binding" "aks_cluster_trusted_access" {
  for_each              = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster }
  kubernetes_cluster_id = each.value.kubernetes_cluster_id
  name                  = substr("axso-np-appl-ssp-test-aks", 0, 23)
  roles                 = ["Microsoft.DataProtection/backupVaults/backup-operator"]
  source_resource_id    = azurerm_data_protection_backup_vault.data_protection_backup_vault.id
}


resource "azurerm_kubernetes_cluster_extension" "kubernetes_cluster_extension" {
  for_each          = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster }
  name              = each.value.kubernetes_cluster_name
  cluster_id        = each.value.kubernetes_cluster_id
  extension_type    = "Microsoft.DataProtection.Kubernetes"
  release_train     = "stable"
  release_namespace = "dataprotection-microsoft"
  configuration_settings = {
    "configuration.backupStorageLocation.bucket"                = var.kubernetes_cluster_storage_account_config.kubernetes_cluster_backup_storage_account_blob_name
    "configuration.backupStorageLocation.config.resourceGroup"  = var.kubernetes_cluster_storage_account_config.kubernetes_cluster_backup_storage_account_resource_group_name
    "configuration.backupStorageLocation.config.storageAccount" = var.kubernetes_cluster_storage_account_config.kubernetes_cluster_backup_storage_account_name
    "configuration.backupStorageLocation.config.subscriptionId" = local.snapshot_subscription_id
    "credentials.tenantId"                                      = "8619c67c-945a-48ae-8e77-35b1b71c9b98"
  }
  depends_on = [azurerm_storage_container.storage_container]
}

#RBAC

resource "azurerm_role_assignment" "vault_account_contributor_on_sa_aks" {
  for_each             = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster }
  scope                = data.azurerm_storage_account.storage_account_aks[0].id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_kubernetes_cluster_extension.kubernetes_cluster_extension[each.value.kubernetes_cluster_name].aks_assigned_identity[0].principal_id
}

resource "azurerm_role_assignment" "vault_reader_on_aks" {
  for_each             = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster }
  scope                = each.value.kubernetes_cluster_id
  role_definition_name = "Reader"
  principal_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.identity[0].principal_id
}



resource "azurerm_role_assignment" "vault_data_operator_on_snap_rg" {
  for_each             = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster }
  scope                = var.snapshot_resource_group_id
  role_definition_name = "Data Operator for Managed Disks"
  principal_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "vault_data_contributor_on_storage" {
  for_each             = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster }
  scope                = data.azurerm_storage_account.storage_account_aks[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_reader_on_snap_rg" {
  # If the snapshot resource group is the same as the Kubernetes-managed resource group, we do not add the role assignment, as it already has the required permissions
  for_each             = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster if "mc_${kubernetes_cluster.kubernetes_cluster_name}" != kubernetes_cluster.kubernetes_cluster_resource_group_name }
  scope                = var.snapshot_resource_group_id
  role_definition_name = "Contributor"
  principal_id         = each.value.kubernetes_cluster_identity_data_object ? data.azuread_service_principal.aks_application[each.key].object_id : each.value.kubernetes_cluster_identity_object_id
}


resource "time_sleep" "wait_30_seconds" {
  depends_on = [
    azurerm_role_assignment.vault_account_contributor_on_sa_aks,
    azurerm_role_assignment.vault_reader_on_aks,
    azurerm_role_assignment.vault_data_operator_on_snap_rg,
    azurerm_role_assignment.vault_data_contributor_on_storage,
    azurerm_role_assignment.vault_reader_on_snap_rg,
    azurerm_role_assignment.aks_reader_on_snap_rg
  ]
  create_duration = "30s"
}
resource "azurerm_data_protection_backup_instance_kubernetes_cluster" "data_protection_backup_instance_kubernetes_cluster" {
  for_each                     = { for idx, kubernetes_cluster in var.kubernetes_cluster_backup_config : kubernetes_cluster.kubernetes_cluster_name => kubernetes_cluster }
  name                         = each.value.kubernetes_cluster_name
  location                     = var.location
  vault_id                     = azurerm_data_protection_backup_vault.data_protection_backup_vault.id
  kubernetes_cluster_id        = each.value.kubernetes_cluster_id
  snapshot_resource_group_name = local.snapshot_resource_group_name
  backup_policy_id             = azurerm_data_protection_backup_policy_kubernetes_cluster.data_protection_backup_policy_kubernetes_cluster[each.value.kubernetes_cluster_backup_policy_name].id

  dynamic "backup_datasource_parameters" {
    for_each = each.value.backup_datasource_parameters != null ? [each.value.backup_datasource_parameters] : []
    content {
      excluded_namespaces              = backup_datasource_parameters.value.excluded_namespaces
      excluded_resource_types          = backup_datasource_parameters.value.excluded_resource_types
      cluster_scoped_resources_enabled = backup_datasource_parameters.value.cluster_scoped_resources_enabled
      included_namespaces              = backup_datasource_parameters.value.included_namespaces
      included_resource_types          = backup_datasource_parameters.value.included_resource_types
      label_selectors                  = backup_datasource_parameters.value.label_selectors
      volume_snapshot_enabled          = backup_datasource_parameters.value.volume_snapshot_enabled
    }

  }



  depends_on = [
    time_sleep.wait_30_seconds
  ]
}




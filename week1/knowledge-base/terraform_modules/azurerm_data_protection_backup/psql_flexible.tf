# Aks Backup

resource "azurerm_data_protection_backup_policy_postgresql_flexible_server" "data_protection_backup_policy_postgresql_flexible_server" {
  for_each                        = { for idx, psql_flexible_server_backup_policy in var.psql_flexible_server_backup_policy : psql_flexible_server_backup_policy.psql_flexible_server_backup_policy_name => psql_flexible_server_backup_policy }
  name                            = "${local.data_protection_backup_policy_psql}-${each.value.psql_flexible_server_backup_policy_name}"
  vault_id                        = azurerm_data_protection_backup_vault.data_protection_backup_vault.id
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
        data_store_type = "VaultStore"
        duration        = retention_rule.value.lifecycle.duration
      }
    }

  }
  dynamic "default_retention_rule" {
    for_each = each.value.default_retention_rule != null ? each.value.default_retention_rule : {}
    content {
      life_cycle {
        data_store_type = "VaultStore"
        duration        = default_retention_rule.value.duration
      }
    }

  }

}


#RBAC

resource "azurerm_role_assignment" "vault_account_contributor_on_psql_flexible_server" {
  for_each             = { for idx, psql_flexible_server in var.psql_flexible_server_backup_config : psql_flexible_server.psql_flexible_server_name => psql_flexible_server }
  scope                = data.azurerm_postgresql_flexible_server.postgresql_flexible_server[each.value.psql_flexible_server_name].id
  role_definition_name = "PostgreSQL Flexible Server Long Term Retention Backup Role"
  principal_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.identity[0].principal_id
}


resource "time_sleep" "wait_30_seconds_psql_flexible_server" {
  depends_on = [
    azurerm_role_assignment.vault_account_contributor_on_psql_flexible_server
  ]
  create_duration = "30s"
}

resource "azurerm_data_protection_backup_instance_postgresql_flexible_server" "data_protection_backup_instance_postgresql_flexible_server" {
  for_each         = { for idx, psql_flexible_server in var.psql_flexible_server_backup_config : psql_flexible_server.psql_flexible_server_name => psql_flexible_server }
  name             = each.value.psql_flexible_server_name
  location         = var.location
  vault_id         = azurerm_data_protection_backup_vault.data_protection_backup_vault.id
  server_id        = data.azurerm_postgresql_flexible_server.postgresql_flexible_server[each.value.psql_flexible_server_name].id
  backup_policy_id = azurerm_data_protection_backup_policy_postgresql_flexible_server.data_protection_backup_policy_postgresql_flexible_server[each.value.psql_flexible_server_backup_policy_name].id
  depends_on       = [time_sleep.wait_30_seconds_psql_flexible_server]
}


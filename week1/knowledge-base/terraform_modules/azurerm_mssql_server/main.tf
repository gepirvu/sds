###### MS SQL Server ######
resource "azurerm_mssql_server" "mssql_server" {
  name                          = local.mssql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.server_version
  minimum_tls_version           = 1.2
  public_network_access_enabled = false

  administrator_login          = var.login_username
  administrator_login_password = local.administrator_password

  dynamic "azuread_administrator" {
    for_each = var.mssql_administrator_group != null ? [var.mssql_administrator_group] : []
    content {
      login_username              = data.azuread_group.mssql_administrator_group[0].display_name
      object_id                   = data.azuread_group.mssql_administrator_group[0].object_id
      tenant_id                   = data.azurerm_subscription.primary.tenant_id
      azuread_authentication_only = var.azuread_authentication_only
    }

  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "random_password" "msql_administrator_password" {
  length           = 32
  special          = true
  override_special = "@#%&*()-_=+[]{}<>:?"
}

resource "random_string" "string" {
  length      = 4
  upper       = false
  min_numeric = 1
  special     = false
}
resource "azurerm_key_vault_secret" "mysql_password" {
  name            = "${local.mssql_server_name}-password-${random_string.string.result}"
  value           = local.administrator_password
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  expiration_date = local.expiration_date
  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }
}


#MS SQL Server identity access to storage account - to write vulnerability scan results and audit logs
resource "azurerm_role_assignment" "sa_role_assignment" {
  scope                = data.azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mssql_server.mssql_server.identity[0].principal_id
}

#Create container to store vulnerability scan results
resource "azurerm_storage_container" "vulnerability_scan_results" {
  name                  = "mssql-vulnerability-scans"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
  depends_on            = [azurerm_role_assignment.sa_role_assignment]
}

#Enable mssql server extended auditing policy
resource "azurerm_mssql_server_extended_auditing_policy" "auditing_policy" {
  server_id                       = azurerm_mssql_server.mssql_server.id
  storage_endpoint                = data.azurerm_storage_account.storage_account.primary_blob_endpoint
  storage_account_subscription_id = data.azurerm_subscription.primary.subscription_id
  retention_in_days               = 90
  log_monitoring_enabled          = false

  depends_on = [
    azurerm_mssql_server.mssql_server,
    azurerm_role_assignment.sa_role_assignment
  ]
}

#enable mssql server security alert policy
resource "azurerm_mssql_server_security_alert_policy" "policy" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.mssql_server.name
  state               = "Enabled"
  email_addresses     = var.email_accounts
}

#enable mssql server vulnerability assessment
resource "azurerm_mssql_server_vulnerability_assessment" "vunerability_assessment" {
  count                           = var.azurerm_mssql_server_vulnerability_assessment_enabled ? 1 : 0
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.policy.id
  storage_container_path          = "${data.azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.vulnerability_scan_results.name}/"
  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = var.email_accounts
  }
}

#MS SQL Server Private Endpoint
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${azurerm_mssql_server.mssql_server.name}-pe"
  location            = var.location
  resource_group_name = var.network_resource_group_name
  subnet_id           = data.azurerm_subnet.mssql_subnet.id

  private_service_connection {
    name                           = "${azurerm_mssql_server.mssql_server.name}-pe-sc"
    private_connection_resource_id = azurerm_mssql_server.mssql_server.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "privatelink.database.windows.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

#MS SQL Server Elastic Pool
resource "azurerm_mssql_elasticpool" "msssql_elastic_pool" {
  count               = var.create_elastic_pool ? 1 : 0
  name                = var.elastic_pool_config.name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_mssql_server.mssql_server.name
  max_size_gb         = var.elastic_pool_config.max_size_gb

  sku {
    name     = var.elastic_pool_config.sku_name
    tier     = var.elastic_pool_config.sku_tier
    family   = var.elastic_pool_config.sku_family
    capacity = var.elastic_pool_config.sku_capacity
  }

  per_database_settings {
    min_capacity = var.elastic_pool_config.per_db_min_capacity
    max_capacity = var.elastic_pool_config.per_db_max_capacity
  }

  zone_redundant = var.elastic_pool_config.zone_redundant

  lifecycle {
    ignore_changes = [tags]
  }
}

#MS SQL Server Database
resource "azurerm_mssql_database" "databases" {
  for_each        = { for each in var.mssql_databases : each.db_name => each if each.create_db == true }
  name            = each.value.db_name
  server_id       = azurerm_mssql_server.mssql_server.id
  elastic_pool_id = each.value.attach_to_elasticpool ? azurerm_mssql_elasticpool.msssql_elastic_pool[0].id : null

  collation    = each.value.collation
  create_mode  = each.value.create_mode
  max_size_gb  = each.value.max_size_gb
  min_capacity = startswith(each.value.min_capacity, "GP_S") ? each.value.min_capacity : null

  sku_name                    = each.value.sku_name
  zone_redundant              = each.value.zone_redundant
  storage_account_type        = each.value.storage_account_type
  auto_pause_delay_in_minutes = startswith(each.value.auto_pause_delay_in_minutes, "GP_S") == true ? each.value.auto_pause_delay_in_minutes : null

  threat_detection_policy {
    state                = var.threat_detection_policy
    email_account_admins = var.threat_detection_policy
    email_addresses      = var.email_accounts
    storage_endpoint     = data.azurerm_storage_account.storage_account.primary_blob_endpoint
    // storage_account_access_key = data.azurerm_storage_account.storage_account.primary_access_key
    retention_days = 90
  }

  short_term_retention_policy {
    retention_days = each.value.short_term_retention_days
  }

  long_term_retention_policy {
    weekly_retention = each.value.ltr_weekly_retention
    week_of_year     = 1
  }

  lifecycle {
    ignore_changes = [tags]
  }

}
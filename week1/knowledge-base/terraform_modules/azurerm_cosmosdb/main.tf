resource "azurerm_key_vault_key" "key_vault_key" {
  for_each        = var.cosmosdb_accounts != null ? { for cosmosdb_account in var.cosmosdb_accounts : cosmosdb_account.name => cosmosdb_account if cosmosdb_account.cosmosdb_type != "psql" } : {}
  name            = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-cosmos-${each.value.name}-cmk-${random_string.cmk_suffix.result}")
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = local.expiration_date
  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }
    expire_after         = "P365D"
    notify_before_expiry = "P45D"
  }

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }

}

resource "azurerm_role_assignment" "role_assignment_cosmos" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = data.azuread_service_principal.cosmos_db.object_id
}

resource "azurerm_role_assignment" "role_assignment_identity" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = data.azurerm_user_assigned_identity.umids[tolist(var.umids_names)[0]].principal_id
}

# Sleep for RBACs to take effect

resource "time_sleep" "rbac_sleep" {
  create_duration = "120s"
  depends_on      = [azurerm_role_assignment.role_assignment_identity, azurerm_role_assignment.role_assignment_cosmos]
}


resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  for_each            = var.cosmosdb_accounts != null ? { for cosmosdb_account in var.cosmosdb_accounts : cosmosdb_account.name => cosmosdb_account if cosmosdb_account.cosmosdb_type != "psql" } : {}
  name                = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-cosmos-${each.value.name}")
  location            = var.location
  resource_group_name = var.resource_group_name

  #Configuration
  offer_type = "Standard"
  kind       = local.type[each.key].kind

  free_tier_enabled          = each.value.free_tier_enabled
  analytical_storage_enabled = each.value.analytical_storage_enabled

  default_identity_type = var.default_identity_type == "UserAssignedIdentity" ? join("=", ["UserAssignedIdentity", data.azurerm_user_assigned_identity.umids[tolist(var.umids_names)[0]].id]) : var.default_identity_type

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned,UserAssigned" ? [for identity in data.azurerm_user_assigned_identity.umids : identity.id] : []
    }
  }

  automatic_failover_enabled = true
  partition_merge_enabled    = false # Not supported for CMK encryption
  burst_capacity_enabled     = each.value.burst_capacity_enabled


  # Security

  access_key_metadata_writes_enabled    = false
  network_acl_bypass_for_azure_services = false
  local_authentication_disabled         = false

  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = false

  key_vault_key_id    = azurerm_key_vault_key.key_vault_key[each.value.name].versionless_id
  minimal_tls_version = "Tls12"


  # Mongo
  mongo_server_version = each.value.mongo_server_version

  dynamic "consistency_policy" {
    for_each = each.value.consistency_policy != null ? { for consistency_policy in each.value.consistency_policy : consistency_policy.name => consistency_policy } : {}
    content {
      consistency_level       = consistency_policy.value.consistency_level
      max_interval_in_seconds = consistency_policy.value.consistency_level == "BoundedStaleness" ? consistency_policy.value.max_interval_in_seconds : null
      max_staleness_prefix    = consistency_policy.value.consistency_level == "BoundedStaleness" ? consistency_policy.value.max_staleness_prefix : null
    }
  }

  dynamic "geo_location" {
    for_each = each.value.geo_location != null ? { for geo_location in each.value.geo_location : geo_location.location => geo_location } : {}
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }


  dynamic "capabilities" {
    for_each = each.value.capabilities != null ? { for capabilities in each.value.capabilities : capabilities.name => capabilities } : {}
    content {
      name = capabilities.value.name
    }

  }

  dynamic "analytical_storage" {
    for_each = each.value.analytical_storage != null ? { for analytical_storage in each.value.analytical_storage : analytical_storage.name => analytical_storage } : {}
    content {
      schema_type = analytical_storage.value.schema_type
    }

  }

  dynamic "capacity" {
    for_each = each.value.capacity != null ? { for capacity in each.value.capacity : capacity.total_throughput_limit => capacity } : {}
    content {
      total_throughput_limit = capacity.value.total_throughput_limit
    }

  }

  dynamic "backup" {
    for_each = each.value.backup != null ? { for backup in each.value.backup : backup.name => backup } : {}
    content {
      type                = backup.value.type
      tier                = backup.value.type == "Periodic" ? null : backup.value.tier
      interval_in_minutes = backup.value.type == "Periodic" ? backup.value.interval_in_minutes : null
      retention_in_hours  = backup.value.type == "Periodic" ? backup.value.retention_in_hours : null
      storage_redundancy  = backup.value.type == "Periodic" ? backup.value.storage_redundancy : null
    }

  }

  dynamic "cors_rule" {
    for_each = each.value.cors_rule != null ? { for cors_rule in each.value.cors_rule : cors_rule.name => cors_rule } : {}
    content {
      allowed_headers    = cors_rule.value.allowed_headers
      allowed_methods    = cors_rule.value.allowed_methods
      allowed_origins    = cors_rule.value.allowed_origins
      exposed_headers    = cors_rule.value.exposed_headers
      max_age_in_seconds = cors_rule.value.max_age_in_seconds
    }

  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [time_sleep.rbac_sleep]

}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = var.cosmosdb_accounts != null ? { for cosmosdb_account in var.cosmosdb_accounts : cosmosdb_account.name => cosmosdb_account if cosmosdb_account.cosmosdb_type != "psql" } : {}

  name                = "${azurerm_cosmosdb_account.cosmosdb_account[each.key].name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnets.id

  private_service_connection {
    name                           = "${azurerm_cosmosdb_account.cosmosdb_account[each.key].name}-pe-sc"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb_account[each.value.name].id
    is_manual_connection           = false
    subresource_names              = [local.subresource_names[each.key].subresource_name] # Adjust this based on your CosmosDB type
  }

  # Creating the private_dns_zone_group for each DNS zone
  private_dns_zone_group {
    name                 = "${azurerm_cosmosdb_account.cosmosdb_account[each.key].name}-dns-zone-group"
    private_dns_zone_ids = ["/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/${local.dns_zones[each.key].dns_zone}"]
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

#Cosmos for Postgres

resource "random_password" "password" {
  for_each         = var.cosmosdb_postgres != null ? { for cosmosdb_postgre in var.cosmosdb_postgres : cosmosdb_postgre.name => cosmosdb_postgre } : {}
  length           = "16"
  special          = true
  min_special      = 1
  min_upper        = 1
  override_special = "/@\" "
}

resource "azurerm_key_vault_secret" "password_secret" {
  for_each        = var.cosmosdb_postgres != null ? { for cosmosdb_postgre in var.cosmosdb_postgres : cosmosdb_postgre.name => cosmosdb_postgre } : {}
  name            = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-cosmos-${each.value.name}-cmk-${random_string.cmk_suffix.result}")
  key_vault_id    = data.azurerm_key_vault.key_vault.id
  expiration_date = local.expiration_date
  value           = random_password.password[each.key].result

  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }

}


resource "azurerm_cosmosdb_postgresql_cluster" "cosmosdb_postgresql_cluster" {
  for_each                     = var.cosmosdb_postgres != null ? { for cosmosdb_postgre in var.cosmosdb_postgres : cosmosdb_postgre.name => cosmosdb_postgre } : {}
  name                         = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-cosmos-${each.value.name}")
  resource_group_name          = var.resource_group_name
  location                     = var.location
  administrator_login_password = random_password.password[each.key].result
  sql_version                  = each.value.sql_version

  node_count    = each.value.node_count
  citus_version = each.value.citus_version

  coordinator_public_ip_access_enabled = false
  node_public_ip_access_enabled        = false

  coordinator_server_edition      = each.value.coordinator_server_edition
  coordinator_storage_quota_in_mb = each.value.coordinator_storage_quota_in_mb
  coordinator_vcore_count         = each.value.coordinator_vcore_count

  node_server_edition      = each.value.node_server_edition
  node_storage_quota_in_mb = each.value.node_storage_quota_in_mb
  node_vcores              = each.value.node_vcores


  ha_enabled = each.value.ha_enabled

  dynamic "maintenance_window" {
    for_each = each.value.maintenance_window != null ? { for maintenance_window in [each.value.maintenance_window] : maintenance_window.day_of_week => maintenance_window } : {}
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }

  }

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_private_endpoint" "private_endpoint_postgres" {
  for_each = var.cosmosdb_postgres != null ? { for cosmosdb_postgre in var.cosmosdb_postgres : cosmosdb_postgre.name => cosmosdb_postgre } : {}

  name                = "${azurerm_cosmosdb_postgresql_cluster.cosmosdb_postgresql_cluster[each.key].name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnets.id

  private_service_connection {
    name                           = "${azurerm_cosmosdb_postgresql_cluster.cosmosdb_postgresql_cluster[each.key].name}-pe-sc"
    private_connection_resource_id = azurerm_cosmosdb_postgresql_cluster.cosmosdb_postgresql_cluster[each.value.name].id
    is_manual_connection           = false
    subresource_names              = ["Coordinator"] # Adjust this based on your CosmosDB type
  }

  # Creating the private_dns_zone_group for each DNS zone
  private_dns_zone_group {
    name                 = "${azurerm_cosmosdb_postgresql_cluster.cosmosdb_postgresql_cluster[each.key].name}-dns-zone-group"
    private_dns_zone_ids = [local.psqldnsid]
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

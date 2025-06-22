
#------------------------------------------#
# PostgreSQL flexible server - Admin login #
#------------------------------------------#

# Note:PostgreSQL flexible server local admin login must be created when usig default create mode.

resource "random_password" "password" {
  length           = var.pass_length
  special          = true
  override_special = "/@\" "
}

# Store username and password in KeyVault

resource "azurerm_key_vault_secret" "username_secret" {
  count           = var.password_auth_enabled != null || var.active_directory_auth_enabled == true ? 1 : 0
  name            = var.username_secret_name
  value           = var.administrator_login_name
  key_vault_id    = data.azurerm_key_vault.keyvault[0].id
  expiration_date = timeadd(timestamp(), "552600m")
  content_type    = "text/plain"
  lifecycle {
    ignore_changes = [expiration_date]
  }
}

resource "azurerm_key_vault_secret" "password_secret" {
  count           = var.password_auth_enabled != null || var.active_directory_auth_enabled == true ? 1 : 0
  name            = var.password_secret_name
  value           = random_password.password.result
  key_vault_id    = data.azurerm_key_vault.keyvault[0].id
  expiration_date = timeadd(timestamp(), "552600m")
  content_type    = "text/plain"
  lifecycle {
    ignore_changes = [expiration_date]
  }
}

#----------------------------#
# PostgreSQL flexible server #
#----------------------------#

resource "azurerm_postgresql_flexible_server" "pgsqlflexible_server" {

  # General configuration
  name                = local.pgsqlflexible_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = var.pgsql_version
  sku_name            = var.sku_name


  storage_mb   = var.storage_mb
  storage_tier = var.storage_tier

  auto_grow_enabled = var.auto_grow_enabled

  # Network configuration

  delegated_subnet_id           = var.vnet_integration_enable && var.psql_subnet_name != null ? data.azurerm_subnet.pgsql-subnet.id : null
  private_dns_zone_id           = var.vnet_integration_enable && var.psql_subnet_name != null ? local.pgsql_dns_id : null
  public_network_access_enabled = var.vnet_integration_enable && var.psql_subnet_name != null ? false : true

  # Authentication configuration
  administrator_login    = var.password_auth_enabled != null || var.active_directory_auth_enabled == true ? azurerm_key_vault_secret.username_secret[0].value : null
  administrator_password = var.password_auth_enabled != null || var.active_directory_auth_enabled == true ? azurerm_key_vault_secret.password_secret[0].value : null

  dynamic "authentication" {
    for_each = var.active_directory_auth_enabled != null || var.active_directory_auth_enabled == false ? [1] : []

    content {
      active_directory_auth_enabled = var.active_directory_auth_enabled != null || var.active_directory_auth_enabled == false ? var.active_directory_auth_enabled : null
      password_auth_enabled         = var.password_auth_enabled
      tenant_id                     = var.active_directory_auth_enabled != null || var.active_directory_auth_enabled == false ? data.azurerm_client_config.current.tenant_id : null
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? { identity = true } : {}

    content {
      type         = can(regex("SystemAssigned", var.identity_type)) && can(regex("UserAssigned", var.identity_type)) ? "SystemAssigned, UserAssigned" : can(regex("SystemAssigned", var.identity_type)) ? "SystemAssigned" : can(regex("UserAssigned", var.identity_type)) ? "UserAssigned" : null
      identity_ids = can(regex("UserAssigned", var.identity_type)) ? values(data.azurerm_user_assigned_identity.pgsql_umids)[*].id : null
    }
  }

  # High availability configuration

  dynamic "high_availability" {
    for_each = var.high_availability_required ? [1] : []
    content {
      mode = var.high_availability_mode
    }
  }

  # Backup configuration
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled



  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone,
      tags
    ]
  }

  depends_on = [azurerm_key_vault_secret.username_secret, azurerm_key_vault_secret.password_secret]
}

#-----------------------------------------------------------#
# PostgreSQL flexible server PE                             #
#-----------------------------------------------------------#

resource "azurerm_private_endpoint" "private_endpoint" {
  count               = var.vnet_integration_enable ? 0 : 1
  name                = "${local.pgsqlflexible_server_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pgsql-subnet.id

  private_service_connection {
    name                           = "${local.pgsqlflexible_server_name}-pe-sc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.pgsqlflexible_server.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }

  private_dns_zone_group {
    name                 = "privatelink.postgres.cosmos.azure.com"
    private_dns_zone_ids = [local.pgsql_dns_id]
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

#-----------------------------------------------------------#
# PostgreSQL flexible server active directory administrator #
#-----------------------------------------------------------#

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "pgsqlflexible_server_admin" {
  count               = var.active_directory_auth_enabled ? 1 : 0
  server_name         = azurerm_postgresql_flexible_server.pgsqlflexible_server.name
  resource_group_name = azurerm_postgresql_flexible_server.pgsqlflexible_server.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azuread_group.postgresql_administrator_group[0].object_id
  principal_name      = data.azuread_group.postgresql_administrator_group[0].display_name
  principal_type      = "Group"

  depends_on = [azurerm_postgresql_flexible_server.pgsqlflexible_server]
}

resource "azurerm_route" "network_route" {
  for_each               = var.active_directory_auth_enabled && var.route_table_name != null ? { for each in local.udr_config.routes : each.route_name => each } : {}
  name                   = each.value.route_name
  resource_group_name    = var.virtual_network_rg
  route_table_name       = var.route_table_name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_ip
}


#-------------------------------------#
# PostgreSQL flexible server database #
#-------------------------------------#

# PostgreSQL flexible server database

resource "azurerm_postgresql_flexible_server_database" "postgresql-flexible-server-database" {
  for_each  = var.postgresql_flexible_server_databases != null ? var.postgresql_flexible_server_databases : {}
  name      = each.value.database_name
  server_id = azurerm_postgresql_flexible_server.pgsqlflexible_server.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  depends_on = [azurerm_postgresql_flexible_server.pgsqlflexible_server]
}


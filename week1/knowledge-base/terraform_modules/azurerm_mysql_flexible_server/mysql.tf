#===========================================================================================================================================#
# MySQL Flexible Server                                                                                                                     
#===========================================================================================================================================#

resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = local.mysql_flexible_server_name

  # Authentication
  administrator_login    = var.administrator_login
  administrator_password = local.administrator_password

  dynamic "identity" {
    for_each = var.user_assigned_identity_name != "" ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = [local.user_assigned_identity_id]
    }
  }

  # SQL server configuration
  sku_name            = var.sku_name
  version             = var.mysql_version
  zone                = var.zone != null ? var.zone : "2"
  create_mode         = var.create_mode
  delegated_subnet_id = local.delegated_subnet_id
  private_dns_zone_id = local.private_dns_zone_id

  # Backup and restore configuration
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  source_server_id             = var.source_server_id

  # High availability configuration
  dynamic "high_availability" {
    for_each = toset(var.high_availability != null ? [var.high_availability] : [])

    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = lookup(high_availability.value, "standby_availability_zone", 2)
    }
  }

  # Maintenance window configuration

  dynamic "maintenance_window" {
    for_each = toset(var.maintenance_window != null ? [var.maintenance_window] : [])

    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week", 0)
      start_hour   = lookup(maintenance_window.value, "start_hour", 0)
      start_minute = lookup(maintenance_window.value, "start_minute", 0)
    }
  }

  dynamic "storage" {
    for_each = toset(var.storage != null ? [var.storage] : [])

    content {
      auto_grow_enabled  = lookup(storage.value, "auto_grow_enabled", true)
      io_scaling_enabled = lookup(storage.value, "io_scaling_enabled", false)
      iops               = lookup(storage.value, "iops", 360)
      size_gb            = lookup(storage.value, "size_gb", 20)
    }
  }

  lifecycle {
    ignore_changes = [tags, zone, high_availability[0].mode, high_availability[0].standby_availability_zone]
  }
}

#===========================================================================================================================================#
# MySQL Active Directory Administrator                                                                                                                    
#===========================================================================================================================================#

resource "azurerm_mysql_flexible_server_active_directory_administrator" "mysql_flexible_server_active_directory_administrator" {
  count = var.mysql_administrator_group != null ? 1 : 0

  server_id   = azurerm_mysql_flexible_server.mysql_flexible_server.id
  identity_id = local.user_assigned_identity_id
  login       = data.azuread_group.mysql_administrator_group[0].display_name
  object_id   = data.azuread_group.mysql_administrator_group[0].object_id
  tenant_id   = data.azurerm_client_config.current.tenant_id
}

#===========================================================================================================================================#
# MySQL Databases                                                                                                                    
#===========================================================================================================================================#

resource "azurerm_mysql_flexible_database" "mysql_flexible_db" {
  for_each = var.databases

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  charset             = lookup(each.value, "charset", "utf8")
  collation           = lookup(each.value, "collation", "utf8_general_ci")
}

#===========================================================================================================================================#
# MySQL Configuration                                                                                                                    
#===========================================================================================================================================#

resource "azurerm_mysql_flexible_server_configuration" "mysql_flexible_server_config" {
  for_each = merge(local.default_mysql_options, var.mysql_options)

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  value               = each.value
}

#===========================================================================================================================================#
# MySQL Firewall Rules                                                                                                                    
#===========================================================================================================================================#

resource "azurerm_mysql_flexible_server_firewall_rule" "firewall_rules" {
  for_each = var.allowed_cidrs

  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, -1)
}

#===========================================================================================================================================#
# MySQL - Random password                                                                                                                   
#===========================================================================================================================================#

resource "random_password" "mysql_administrator_password" {
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

#===========================================================================================================================================#
# MySQL Password in the Key Vault                                                                                                                  
#===========================================================================================================================================#

resource "azurerm_key_vault_secret" "mysql_password" {
  name            = "${local.mysql_flexible_server_name}-password-${random_string.string.result}"
  value           = local.administrator_password
  key_vault_id    = local.key_vault_id
  expiration_date = var.administrator_password_expiration_date_secret
  lifecycle {
    ignore_changes = [
      expiration_date, tags
    ]
  }
}

#===========================================================================================================================================#
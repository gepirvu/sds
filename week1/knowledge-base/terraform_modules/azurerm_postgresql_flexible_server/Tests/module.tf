#=======================================================================================================================
# PostgreSQL flexible server
#=======================================================================================================================

module "axso_postgresql_flexible_server" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_postgresql_flexible_server?ref=~{gitRef}~"

  # PostgreSQL flexible server general configuration
  resource_group_name = var.resource_group_name
  location            = var.location

  # Naming convention for postgresql flexible server
  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment

  # PostgreSQL flexible server configuration
  pgsql_version     = var.pgsql_version
  sku_name          = var.sku_name
  storage_mb        = var.storage_mb
  storage_tier      = var.storage_tier
  auto_grow_enabled = var.auto_grow_enabled

  # Network configuration
  vnet_integration_enable = var.vnet_integration_enable
  psql_subnet_name        = var.psql_subnet_name
  virtual_network_name    = var.virtual_network_name
  virtual_network_rg      = var.virtual_network_rg

  # Authentication configuration
  password_auth_enabled          = var.password_auth_enabled
  route_table_name               = var.route_table_name
  keyvault_name                  = var.keyvault_name
  keyvault_resource_group_name   = var.keyvault_resource_group_name
  active_directory_auth_enabled  = var.active_directory_auth_enabled
  postgresql_administrator_group = var.postgresql_administrator_group

  # Identity configuration
  identity_type  = var.identity_type
  identity_names = var.identity_names

  # High availability configuration
  high_availability_required = var.high_availability_required
  high_availability_mode     = var.high_availability_required ? var.high_availability_mode : null

  # Backup configuration
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  # Databadses configuration
  postgresql_flexible_server_databases = var.postgresql_flexible_server_databases
}

#=======================================================================================================================
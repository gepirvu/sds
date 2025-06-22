module "axso_mysql_flexible_server" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_mysql_flexible_server?ref=~{gitRef}~"

  # Generic
  resource_group_name = var.resource_group_name
  location            = var.location
  project_name        = var.project_name
  subscription        = var.subscription
  environment         = var.environment

  # SQL server configuration
  mysql_version = var.mysql_version
  sku_name      = var.sku_name

  # Authentication
  administrator_login                           = var.administrator_login
  mysql_administrator_group                     = var.mysql_aad_group
  administrator_password_expiration_date_secret = var.admin_password_expiration_date
  user_assigned_identity_name                   = var.umid_name
  key_vault_name                                = var.key_vault_name

  # Storage
  storage = var.storage

  # Backup and restore configuration
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  # Network
  delegated_subnet_details = var.delegated_subnet_details
  allowed_cidrs            = var.allowed_cidrs

  # Maintenance window
  maintenance_window = var.maintenance_window

  mysql_options = var.mysql_options

  # High availability configuration
  high_availability = var.high_availability_mode

  # Databases
  databases = var.databases
}
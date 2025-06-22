# Tenant details

data "azurerm_client_config" "current" {
}

data "azuread_group" "postgresql_administrator_group" {
  count            = var.postgresql_administrator_group != null ? 1 : 0
  display_name     = var.postgresql_administrator_group
  security_enabled = true
}

# Delegated subnet for the PostgreSQL flexible server

data "azurerm_subnet" "pgsql-subnet" {
  name                 = var.psql_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_rg
}

# Key Vault where the PostgreSQL flexible server admin credentials are stored

data "azurerm_key_vault" "keyvault" {
  count               = var.password_auth_enabled != null || var.active_directory_auth_enabled == true ? 1 : 0
  name                = var.keyvault_name
  resource_group_name = var.keyvault_resource_group_name
}

data "azurerm_user_assigned_identity" "pgsql_umids" {
  for_each            = toset(var.identity_names)
  name                = each.key
  resource_group_name = var.resource_group_name
}
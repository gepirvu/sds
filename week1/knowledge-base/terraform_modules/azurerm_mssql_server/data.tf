# Get the subnet ID for the private endpoint for SQL
data "azurerm_subnet" "mssql_subnet" {
  name                 = var.mssql_subnet_name
  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}

# Get the Storage Account details where to store SQL Vulnerability Assessment scan results and audit logs
data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

# Get the Subscription details - auditing policy requires the subscription ID
data "azurerm_subscription" "primary" {
}

data "azuread_group" "mssql_administrator_group" {
  count            = var.mssql_administrator_group != null ? 1 : 0
  display_name     = var.mssql_administrator_group
  security_enabled = true
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

data "azuread_group" "mysql_administrator_group" {
  count            = var.mysql_administrator_group != null ? 1 : 0
  display_name     = var.mysql_administrator_group
  security_enabled = true
}

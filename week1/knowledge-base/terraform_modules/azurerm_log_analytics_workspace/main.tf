resource "azurerm_log_analytics_workspace" "law" {
  name                = local.loga_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_law
  retention_in_days   = var.retention_in_days_law
  lifecycle {
    ignore_changes = [tags]
  }
}
resource "azurerm_monitor_workspace" "monitor_workspace" {
  name                = local.monitor_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
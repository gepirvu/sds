resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location = var.location
  lifecycle {
    ignore_changes = [tags]
  }
}
resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  count               = var.identity_type == "UserAssigned" ? 1 : 0
  name                = local.user_assigned_identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  lifecycle {
    ignore_changes = [tags]
  }
}
data "azurerm_user_assigned_identity" "identity" {
  count               = var.user_assigned_identity_name != "" ? 1 : 0
  name                = var.user_assigned_identity_name
  resource_group_name = var.resource_group_name
}
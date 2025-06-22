resource "azurerm_user_assigned_identity" "user_id" {
  for_each            = toset(var.umid_name)
  name                = "${local.umid_name}-${each.value}-umid"
  resource_group_name = var.resource_group_name
  location            = var.location
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_logic_app_workflow" "logicapp" {
  name                = local.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name


  dynamic "identity" {
    for_each = var.requires_identity == true ? [1] : []
    content {
      identity_ids = data.azurerm_user_assigned_identity.identity[*].id
      type         = "UserAssigned"
    }
  }

  dynamic "identity" {
    for_each = var.requires_identity == false ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  lifecycle {
    ignore_changes = [tags, workflow_parameters, workflow_schema, workflow_version]
  }
}

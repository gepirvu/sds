resource "azurerm_application_insights" "arm_app_insights" {
  name                = local.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
  workspace_id        = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  lifecycle {
    ignore_changes = [tags]
  }
}

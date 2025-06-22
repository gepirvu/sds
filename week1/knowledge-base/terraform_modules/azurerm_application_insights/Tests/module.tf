module "appinsights" {
  source                       = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_application_insights?ref=~{gitRef}~"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  application_type             = var.application_type
  subscription                 = var.subscription
  project_name                 = var.project_name
  environment                  = var.environment
  log_analytics_workspace_name = var.log_analytics_workspace_name
}


module "loga" {
  source                = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_log_analytics_workspace?ref=~{gitRef}~"
  location              = var.location
  resource_group_name   = var.resource_group_name
  project_name          = var.project_name
  subscription          = var.subscription
  environment           = var.environment
  retention_in_days_law = var.retention_in_days_law

}
module "azurerm_monitor_workspace" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_monitor_workspace?ref=~{gitRef}~"
  project_name        = var.project_name
  subscription        = var.subscription
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name
}
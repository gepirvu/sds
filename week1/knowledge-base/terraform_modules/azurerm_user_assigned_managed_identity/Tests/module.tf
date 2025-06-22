module "umid" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_user_assigned_managed_identity?ref=~{gitRef}~"
  umid_name           = var.umid_name
  location            = var.location
  subscription        = var.subscription
  environment         = var.environment
  project_name        = var.project_name
  resource_group_name = var.resource_group_name
}

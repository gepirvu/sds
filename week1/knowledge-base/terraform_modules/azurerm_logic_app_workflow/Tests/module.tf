module "logicapp" {
  source                      = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_logic_app_workflow?ref=~{gitRef}~"
  for_each                    = { for n in var.logic_app : n.logic_app_description => n }
  resource_group_name         = var.resource_group_name
  project_name                = var.project_name
  subscription                = var.subscription
  environment                 = var.environment
  location                    = var.location
  logic_app_description       = each.value.logic_app_description
  requires_identity           = each.value.requires_identity
  user_assigned_identity_name = var.user_assigned_identity_name
}

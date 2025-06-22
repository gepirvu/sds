module "axso_resource_group" {
  for_each     = { for each in var.resource_groups : each.environment => each }
  source       = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_resource_group?ref=~{gitRef}~"
  subscription = each.value.subscription
  project_name = each.value.project_name
  environment  = each.value.environment
  location     = var.location
}

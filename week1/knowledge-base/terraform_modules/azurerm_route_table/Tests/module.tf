module "axso_rt" {
  source                        = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_route_table?ref=~{gitRef}~"
  resource_group_name           = var.resource_group_name
  subscription                  = var.subscription
  project_name                  = var.project_name
  environment                   = var.environment
  location                      = var.location
  usecase                       = var.usecase
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  default_hub_route             = var.default_hub_route
  udr_config                    = var.udr_config

}

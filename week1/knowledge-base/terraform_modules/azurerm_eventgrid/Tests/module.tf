module "azurerm_eventgrid_domains" {
  source                              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_eventgrid?ref=~{gitRef}~"
  subscription                        = var.subscription
  project_name                        = var.project_name
  environment                         = var.environment
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  pe_subnet_name                      = var.pe_subnet_name
  eventgrid_domain_config             = var.eventgrid_domain_config
}
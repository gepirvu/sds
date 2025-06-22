###################
# Module to test  #
###################
module "axso_nsg" {
  source                              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_network_security_group?ref=~{gitRef}~"
  resource_group_name                 = var.resource_group_name
  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  location                            = var.location
  nsgs                                = var.nsgs
}
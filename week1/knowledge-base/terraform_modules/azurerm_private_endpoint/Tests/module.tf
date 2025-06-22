# Test template to perform PE test against key vault
######################################################################################
# PRE-REQS FOR TEST: RG, VNET, Subs, DNS, LINKS - Please remove resources after test #
######################################################################################

###################
# Module to test  #
###################
module "private_endpoint_kv" {
  source                              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_endpoint?ref=~{gitRef}~"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_name                = var.virtual_network_name
  pe_subnet_name                      = var.pe_subnet_name
  private_endpoint_name               = var.private_endpoint_name
  private_connection_resource_id      = var.private_connection_resource_id
  private_dns_zone_group              = var.private_dns_zone_group
  is_manual_connection                = var.is_manual_connection
  subresource_names                   = var.subresource_names
}
module "subnet" {
  for_each                                      = { for each in var.subnet_config : each.subnet_name => each }
  source                                        = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_subnet?ref=~{gitRef}~"
  virtual_network_resource_group_name           = var.virtual_network_resource_group_name
  location                                      = var.location
  virtual_network_name                          = var.virtual_network_name
  custom_name_network_security_group            = each.value.custom_name_network_security_group
  route_table_name                              = each.value.route_table_name
  default_name_network_security_group_create    = each.value.default_name_network_security_group_create
  subnet_name                                   = each.value.subnet_name
  subnet_address_prefixes                       = each.value.subnet_address_prefixes
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  subnet_service_endpoints                      = each.value.subnet_service_endpoints
  subnets_delegation_settings                   = each.value.subnets_delegation_settings
}


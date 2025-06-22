module "onprem_routes" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_route_table_administration?ref=~{gitRef}~"
  for_each            = { for each in var.udr_config.routes : each.route_name => each }
  resource_group_name = var.resource_group_name
  route_table_name    = var.udr_config.route_table_name
  route_name          = each.value.route_name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
  next_hop_ip         = each.value.next_hop_ip
}

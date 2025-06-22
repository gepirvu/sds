resource "azurerm_route_table" "route_table" {
  name                          = local.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_route" "default_route" {
  count                  = var.default_hub_route ? 1 : 0
  name                   = "default-hub-${var.location}"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = local.next_hop_in_ip_address[var.location].hub_ip

}

resource "azurerm_route" "network_route" {
  for_each               = { for each in var.udr_config.routes : each.route_name => each }
  name                   = each.value.route_name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_ip
}



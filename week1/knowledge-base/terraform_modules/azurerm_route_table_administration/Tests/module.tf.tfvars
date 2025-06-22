resource_group_name = "axso-np-appl-ssp-test-rg"

udr_config = {
  route_table_name = "axso-np-appl-ssp-test-rt"
  routes = [
    {
      route_name     = "prod_network_summary"
      address_prefix = "10.54.0.0/16"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    },
    {
      route_name     = "AXUSR_216"
      address_prefix = "10.216.0.0/16"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    },
    {
      route_name     = "AXUSR_217"
      address_prefix = "10.217.0.0/16"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    },
    {
      route_name     = "AXUSR_233"
      address_prefix = "10.233.0.0/16"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    },
    {
      route_name     = "AXUSR_226"
      address_prefix = "10.226.0.0/15"
      next_hop_type  = "VirtualNetworkGateway"
      next_hop_ip    = null
    }
  ]
}
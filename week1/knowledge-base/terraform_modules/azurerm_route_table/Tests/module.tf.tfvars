resource_group_name           = "axso-np-appl-ssp-test-rg"
subscription                  = "np"
project_name                  = "dyos"
environment                   = "test"
location                      = "westeurope"
usecase                       = "psql"
bgp_route_propagation_enabled = false
default_hub_route             = true
udr_config = {
  routes = [
    {
      route_name     = "PSQL_AzureActiveDirectory"
      address_prefix = "AzureActiveDirectory"
      next_hop_type  = "Internet"
      next_hop_ip    = null
    },
    {
      route_name     = "PSQL_SUBNET_DEV"
      address_prefix = "10.84.189.160/28"
      next_hop_type  = "VnetLocal"
      next_hop_ip    = null
    },
    {
      route_name     = "PSQL_SUBNET_UAT"
      address_prefix = "10.84.189.176/28"
      next_hop_type  = "VnetLocal"
      next_hop_ip    = null
    }
  ]
}
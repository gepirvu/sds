variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the route table"
}

variable "udr_config" {
  type = object({
    route_table_name = string
    routes = list(object({
      route_name     = string
      address_prefix = string
      next_hop_type  = string
      next_hop_ip    = string
    }))
  })
  description = "The configuration of the UDR routes"
  default = {
    route_table_name = "axso-tf-test-route-table"
    routes = [
      {
        route_name     = "test-route1"
        address_prefix = "10.217.0.0/16"
        next_hop_type  = "VirtualAppliance"
        next_hop_ip    = null
      }
    ]
  }
}
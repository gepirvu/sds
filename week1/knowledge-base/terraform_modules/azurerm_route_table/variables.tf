variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
  default     = "np"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "environment" {
  type        = string
  description = "The short name of the environment e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "usecase" {
  type        = string
  description = "The usecase of the route table to use in the route table name"
  default     = "psql"
}

variable "location" {
  type        = string
  description = "The location to create the UDR table e.g westeurope"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to place the UDR in (normally core network resource group)"
}

variable "bgp_route_propagation_enabled" {
  type        = bool
  default     = false
  description = "Boolean flag which controls propagation of routes learned by BGP on that route table. "
}

variable "default_hub_route" {
  type        = bool
  default     = true
  description = "Boolean flag which controls the creation of the default route to the hub. True means create."
}

variable "udr_config" {
  type = object({
    routes = list(object({
      route_name     = string
      address_prefix = string
      next_hop_type  = string
      next_hop_ip    = string
    }))
  })
  description = "The configuration of the UDR routes"
  default = {
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
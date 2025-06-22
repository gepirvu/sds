variable "location" {
  type        = string
  description = "The default location where the core network will be created"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the NSG and the Route table"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet, used to identify its purpose."
}

variable "subnet_config" {
  description = "List of subnet configurations."
  type = list(object({
    subnet_name                                   = string
    subnet_address_prefixes                       = list(string)
    default_name_network_security_group_create    = optional(bool)
    custom_name_network_security_group            = optional(string)
    route_table_name                              = optional(string)
    private_endpoint_network_policies_enabled     = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    subnet_service_endpoints                      = optional(list(string))
    subnets_delegation_settings = optional(map(list(object({
      name    = string
      actions = list(string)
    }))))
  }))
}
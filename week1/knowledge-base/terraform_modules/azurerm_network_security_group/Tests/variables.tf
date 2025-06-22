##################################################
# VARIABLES                                      #
##################################################
variable "resource_group_name" {
  type        = string
  description = "value for the resource group name where the NSG should be created (normally the network resource group)"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet where the private endpoint will be created"
}

variable "location" {
  type        = string
  description = "value for the location where the NSG should be created"
  default     = "westeurope"
}

variable "nsgs" {
  type = list(object({
    subnet_name         = string
    associate_to_subnet = bool


    nsg_rules = list(object({
      nsg_rule_name                = optional(string, "default_rule_name")
      priority                     = optional(string, "101")
      direction                    = optional(string, "Any")
      access                       = optional(string, "Allow")
      protocol                     = optional(string, "*")
      source_port_range            = optional(string, null)
      source_port_ranges           = optional(list(string), null)
      destination_port_range       = optional(string, null)
      destination_port_ranges      = optional(list(string), null)
      source_address_prefix        = optional(string, null)
      source_address_prefixes      = optional(list(string), null)
      destination_address_prefix   = optional(string, null)
      destination_address_prefixes = optional(list(string), null)
  })) }))

  default     = []
  description = "Specifies a list of objects to represent Network Security Group(NSG) rules"
}

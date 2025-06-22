#------------------------------------------------------------------------------------------------------------------#
# Generic
#------------------------------------------------------------------------------------------------------------------#

variable "resource_group_name" {
  type        = string
  description = "Specifies the Resource Group that contains Network Security Groups(NSGs) to be configured/administered"
  default     = "rg-where-nsgs-are-located"
  nullable    = false
}

#------------------------------------------------------------------------------------------------------------------#
# Network Security Group Rules
#------------------------------------------------------------------------------------------------------------------#

variable "nsg_name" {
  type        = string
  description = "Specifies the Network Security Group(NSG) name"
  nullable    = false
}

variable "nsg_rules" {
  type = list(object({
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
  }))
  default     = []
  description = "Specifies a list of objects to represent Network Security Group(NSG) rules"
}

#------------------------------------------------------------------------------------------------------------------#
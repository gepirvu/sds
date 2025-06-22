variable "location" {
  type        = string
  description = "The default location where the core network will be created"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "route_table_name" {
  type        = string
  description = "The name of the Azure Route Table to associate with the subnet, if applicable."
  default     = ""
}

variable "default_name_network_security_group_create" {
  type        = bool
  description = "In case is needed NSG will be created"
  default     = false
}

variable "custom_name_network_security_group" {
  type        = string
  description = "The name of the Azure Network Security Group (NSG) to associate with the subnet, if applicable."
  default     = null
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet, used to identify its purpose."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet, used to identify its purpose."
  default     = "dev"
}

variable "subnet_address_prefixes" {
  type        = list(any)
  description = "The address prefixes for the subnet, specifying its IP range."
  default     = []
}

variable "subnet_service_endpoints" {
  type        = list(any)
  description = "A list of service endpoints associated with the subnet."
  default     = []
}

variable "private_endpoint_network_policies_enabled" {
  type        = string
  description = "Enable or Disable network policies for the private endpoint on the subnet. Possible values are 'Disabled', 'Enabled', 'NetworkSecurityGroupEnabled' and 'RouteTableEnabled'. Defaults to 'Disabled'."
  default     = "Disabled"
}

variable "private_link_service_network_policies_enabled" {
  type        = bool
  description = "Controls whether network policies are enabled for private link services in the subnet."
  default     = false
}

variable "subnets_delegation_settings" {
  description = "Configuration delegations on subnet"
  default     = {}
  type        = map(list(any))
}

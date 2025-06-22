#Common vars
variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the private endpoint resource will be created."
  nullable    = false
}


variable "private_endpoint_name" {
  type        = string
  description = "The name of the Private Endpoint."
}

variable "private_connection_resource_id" {
  type        = string
  description = "The Resource ID which the private endpoint should be created for."
}

variable "private_dns_zone_group" {
  type = list(object({
    enabled              = bool
    name                 = string
    private_dns_zone_ids = list(string)
  }))
  default     = []
  description = "List of private dns zone groups to associate with the private endpoint."
}

variable "is_manual_connection" {
  type        = bool
  description = "Boolean flag to specify whether the connection should be manual."
  default     = false
}

variable "subresource_names" {
  type        = list(string)
  description = "A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id. Changing this forces a new resource to be created."
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet where the private endpoint will be created"
}

variable "pe_subnet_name" {
  type        = string
  description = "The name of the subnet where the private endpoint will be created"
}

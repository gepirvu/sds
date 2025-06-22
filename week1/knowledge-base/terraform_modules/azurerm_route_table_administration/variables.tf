variable "route_name" {
  type        = string
  description = "The name of the UDR route to be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the route table"
}

variable "route_table_name" {
  type        = string
  description = "The name of the the UDR table"
}

variable "address_prefix" {
  type        = string
  description = "route address prefix"
}

variable "next_hop_type" {
  type        = string
  description = "route next hop type"
}

variable "next_hop_ip" {
  type        = string
  default     = null
  description = "route next hop type"
}

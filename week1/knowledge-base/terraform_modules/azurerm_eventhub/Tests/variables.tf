## Common

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Specifies azure region/location where resources will be created."
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where Monitor Workspace will be deployed."
}

## EventHub Variables

variable "partition_count" {
  type        = number
  description = "The name of the Resource Group where Monitor Workspace will be deployed."
}

variable "message_retention" {
  type        = number
  description = "The name of the Resource Group where Monitor Workspace will be deployed."
}

## Subnet Data Source

variable "pe_subnet_name" {
  type        = string
  description = "The name of the Resource Group where the private endpoint subnet is deployed."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the Virtual Network hosting the private endpoint subnet."
}

variable "network_resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the Virtual Network is located."
}
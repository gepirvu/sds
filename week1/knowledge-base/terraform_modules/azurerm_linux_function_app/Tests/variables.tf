# Example of defining the input variables for the module to test
# -------------------------------------------------------------#
# variable "location" {
#   type        = string
#   description = "The location/region where the resource group will be created."
#   default     = "westeurope"
# }
# Purpose: Define the variables that will be used in the terraform configuration

# Common Variables

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "The Azure location where the resources will be deployed."
  type        = string
  default     = "West Europe"
}

variable "project_name" {
  type        = string
  default     = "etools"
  description = "The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.."
}

variable "subscription" {
  type        = string
  default     = "p"
  description = "The subscription type e.g. 'p' or 'np'"
}

variable "environment" {
  type        = string
  default     = "prod "
  description = "The environment. e.g. dev, qa, uat, prod"
}

# Data Source Variables

variable "storage_account_name" {
  description = "The name of the Storage Account to be created or used."
  type        = string
}

variable "storage_account_resource_group_name" {
  description = "The name of the resource group where the Storage Account is located."
  type        = string
}

variable "pe_subnet_name" {
  description = "The name of the subnet within the virtual network where the storage account resides."
  type        = string
}

variable "network_name" {
  description = "The name of the virtual network to which the subnet belongs."
  type        = string
}

variable "network_resource_group_name" {
  description = "The name of the resource group where the virtual network is located."
  type        = string
}

# App Service Plan Variables

variable "sku_name" {
  description = "The SKU (pricing tier) of the App Service Plan."
  type        = string
}

variable "zone_balancing_enabled" {
  description = "Should the Service Plan balance across Availability Zones in the region. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "worker_count" {
  description = "The number of Workers (instances) to be allocated."
  type        = number
  default     = 1
}

# Function App Variables

variable "function_app" {
  description = "The Function App variable block. 'usecase' variable will determine the naming of the Function App"
  type = list(object({
    usecase = string
  }))
}

variable "https_only" {
  description = "The name of the virtual network to which the subnet belongs."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enables or Disables public access to the Function App."
  type        = bool
  default     = false
}

variable "vnet_integration_subnet_name" {
  description = "The ID of the subnet for Virtual Network Integration"
  type        = string
}
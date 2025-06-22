#-------------------------------------------------------------------------------------------------------------------#
# General                                                                                                           #
#-------------------------------------------------------------------------------------------------------------------#

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

# Naming Convention

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

# Data sources

variable "redis_umids" {
  type = map(object({
    umid_name    = string
    umid_rg_name = string
  }))
}

variable "pe_subnet_details" {
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
}

#-------------------------------------------------------------------------------------------------------------------#
# Redis                                                                                                             #
#-------------------------------------------------------------------------------------------------------------------#

### Redis Cache - Pricing ###

variable "capacity" {
  type        = number
  default     = 1
  description = "(Optional) The size of the Redis cache to deploy. Valid values are 0, 1, 2, 3, 4, 5, 6. Defaults to 1."
}

variable "family" {
  type        = string
  default     = "C"
  description = "(Optional) The SKU family to use. Valid values are C (for Basic/Standard instances) and P (for Premium instances). Defaults to C."
}

variable "sku_name" {
  type        = string
  default     = "Standard"
  description = "(Optional) The SKU of Redis to use. Valid values are Basic, Standard and Premium. Defaults to Standard."
}

### Redis Cache - Network ###

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not public access is allowed for this Redis instance. Defaults to true."
}

### Redis Cache - Security ###

variable "non_ssl_port_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not the non-ssl Redis server port (6379) is enabled. Defaults to false."
}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "(Optional) The minimum TLS version. Defaults to 1.2."
}

## Redis cache - Authentication ##

variable "active_directory_authentication_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether or not Azure Active Directory authentication is enabled for this Redis instance. Defaults to false."
}

variable "access_keys_authentication_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not access keys are enabled for this Redis instance. Defaults to true."
}

### Redis Cache - Patching ###

variable "enable_patching" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not the Redis instance should be patched. Defaults to false."
}

variable "day_of_week" {
  type        = string
  default     = "Sunday"
  description = "(Optional) The day of the week when a cache can be patched. Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday."
}

variable "start_hour_utc" {
  type        = number
  default     = 0
  description = "(Optional) The start hour after which cache patching can start. Possible values are 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11."
}

### Redis Cache - Authentication ###

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "(Optional) The type of Managed Service Identity to use. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
}

### Redis Cache - Firewall Rules ###

variable "redis_fw_rules" {
  type = map(object({
    name     = string
    start_ip = string
    end_ip   = string
  }))
}
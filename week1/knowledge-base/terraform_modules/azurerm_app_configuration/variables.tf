#-----------------------------------------------------------------------------------------------------------------#
# General                                                                                                         #
#-----------------------------------------------------------------------------------------------------------------#

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

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

#-----------------------------------------------------------------------------------------------------------------#
# App configuration                                                                                               #
#-----------------------------------------------------------------------------------------------------------------#

variable "sku" {
  type        = string
  description = "(Optional) The SKU name of the App Configuration. Possible values are free and standard. Defaults to free"
}

variable "local_auth_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether local authentication methods is enabled. Defaults to true"
}

variable "public_network_access" {
  type        = string
  default     = "Disabled"
  description = "(Optional) The Public Network Access setting of the App Configuration. Possible values are Enabled and Disabled"
}

variable "purge_protection_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether Purge Protection is enabled. This field only works for standard sku. Defaults to false"
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 7
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This field only works for standard sku. This value can be between 1 and 7 days. Defaults to 7. Changing this forces a new resource to be created."
}

variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

#-----------------------------------------------------------------------------------------------------------------#
# App configuration key                                                                                           #
#-----------------------------------------------------------------------------------------------------------------#

variable "app_conf_key" {
  type        = string
  description = "(Required) The name of the App Configuration Key to create. Changing this forces a new resource to be created."
  default     = null
}

variable "app_conf_label" {
  type        = string
  description = "(Optional) The label of the App Configuration Key. Changing this forces a new resource to be created."
  default     = null
}

variable "app_conf_value" {
  type        = any
  description = "(Optional) The value of the App Configuration Key. This should only be set when type is set to kv"
  default     = null
}

variable "key_vault_name" {
  type        = string
  description = "(Required) The name of the Key Vault to be used for storing the App Configuration Key Vault Key. Changing this forces a new resource to be created."
}

#-----------------------------------------------------------------------------------------------------------------#
# Data sources                                                                                                    #
#-----------------------------------------------------------------------------------------------------------------#

variable "app_conf_umids_names" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity names to assign to the App Configuration. Changing this forces a new resource to be created."
  default     = []
}

variable "pe_subnet" {
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
}

#-----------------------------------------------------------------------------------------------------------------#

#RBAC for clients managed identities

variable "app_conf_client_access_umids" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity IDs to give access to the App Configuration. It isnt the identity of the App Configuration. "
  default     = []

}
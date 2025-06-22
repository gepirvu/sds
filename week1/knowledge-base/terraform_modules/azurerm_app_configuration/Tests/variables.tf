#-----------------------------------------------------------------------------------------------------------------#
# General                                                                                                         #
#-----------------------------------------------------------------------------------------------------------------#

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "key_vault_name" {
  type        = string
  description = "(Required) The name of the Key Vault to be used for storing the App Configuration Key Vault Key. Changing this forces a new resource to be created."
}


#-----------------------------------------------------------------------------------------------------------------#
# App configuration and app config keys                                                                           #
#-----------------------------------------------------------------------------------------------------------------#

variable "app_conf" {
  type = list(object({
    project_name               = string,
    subscription               = string,
    environment                = string,
    sku                        = string,
    local_auth_enabled         = bool,
    purge_protection_enabled   = bool,
    soft_delete_retention_days = number,
    identity_type              = string,
    public_network_access      = string,

    pe_subnet = object({
      subnet_name  = string
      vnet_name    = string
      vnet_rg_name = string
    })

    app_conf_key   = string,
    app_conf_label = string,
    app_conf_value = any
  }))

  default     = []
  description = "List of App Configurations to be created and the relevant properties."
}


variable "app_conf_umids_names" {
  type        = list(string)
  description = "(Required) List of User Assigned Managed Identity names to be assigned to the App Configuration. Changing this forces a new resource to be created."

}

#RBAC for clients managed identities

variable "app_conf_client_access_umids" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity IDs to give access to the App Configuration. It isnt the identity of the App Configuration. "
  default     = []

}
#-----------------------------------------------------------------------------------------------------------------#
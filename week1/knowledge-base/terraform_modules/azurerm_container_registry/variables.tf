#===========================================================================================================================================#
# General                                                                                                                                   #
#===========================================================================================================================================#

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
  default     = "prod"
  description = "The environment. e.g. dev, qa, uat, prod"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

#===========================================================================================================================================#
# Container registry                                                                                                                        #
#===========================================================================================================================================#

variable "admin_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
}

variable "retention_policy_in_days" {
  type        = number
  default     = 7
  description = "(Optional) This policy checks if the retention policy is enabled for Azure Container Registry, ensuring that untagged manifests are automatically deleted.. Defaults to 7 days."

}

variable "data_endpoint_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Dedicated data endpoints enhance security by directing data connections through private IPs within your virtual network. Disabled endpoints expose data to the public internet, increasing the risk of interception or breaches. Enabling dedicated data endpoints strengthens your security posture. Defaults to true."

}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether or not public network access is allowed for the container registry. Defaults to false."
}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

variable "georeplications_configuration" {
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
  }))
  default = []
}

variable "allowed_ip_ranges" {
  type        = list(string)
  default     = ["159.168.125.252/30", "159.168.7.144/29", "159.168.126.252/30"]
  description = "List of IP addresses that are allowed to access the container registry. The IP address ranges in CIDR notation. e.g."
}


variable "acr_network_rule_set_default_action" {
  type    = string
  default = "Deny"
}


#===========================================================================================================================================#
# Data sources                                                                                                                              #
#===========================================================================================================================================#

variable "acr_umids" {
  type = list(object({
    umid_name    = string
    umid_rg_name = string
  }))
}

variable "acr_allowed_subnets" {
  type = map(object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  }))
}

variable "pe_subnet" {
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
}

#===========================================================================================================================================#
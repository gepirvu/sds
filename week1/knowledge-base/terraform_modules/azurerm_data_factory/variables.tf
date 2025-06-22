variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "project"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' for prod or 'np' for nonprod"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the data factory"
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "key_vault_name" {
  description = "Name of the keyVault"
  default     = null
}

variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this Data Factory. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

variable "umids_names" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity names to assign to the Data Factory. Changing this forces a new resource to be created."
  default     = []
}

variable "managed_virtual_network_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the Data Factory should be provisioned with a managed virtual network. Defaults to false."
  default     = false

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

variable "global_parameters" {
  description = "A list of global parameters to be created."
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}

variable "vsts_configuration" {
  description = "VSTS configuration"
  type = object({
    account_name = string
    project_name = string
    repository   = string
    branch       = string
    root_folder  = string
    tenant_id    = string
    service_id   = string
    secret_id    = string
  })
  default = null

}

variable "purview_id" {
  description = "The ID of the Purview account to associate with the Data Factory."
  type        = string
  default     = null

}

variable "azure_integration_runtimes" {
  description = "A list of Azure Integration Runtimes for Data Factory."
  type = list(object({
    name                    = string
    description             = optional(string, null)
    cleanup_enabled         = optional(bool, true)
    compute_type            = optional(string, "General")
    core_count              = optional(number, 8)
    time_to_live_min        = optional(number, 0)
    virtual_network_enabled = optional(bool, true)
  }))
  default = [
    {
      name                    = "runtime1"
      description             = "Integration Runtime 1"
      cleanup_enabled         = true
      compute_type            = "General"
      core_count              = 8
      time_to_live_min        = 0
      virtual_network_enabled = false
    }
  ]
}

variable "self_hosted_integration_runtimes" {
  description = "A list of Azure Integration Runtimes Self Hosted for Data Factory."
  type = list(object({
    name        = string
    description = string
  }))
  default = [
    {
      name        = "runtime1"
      description = "Integration Runtime 1"
    }
  ]
}
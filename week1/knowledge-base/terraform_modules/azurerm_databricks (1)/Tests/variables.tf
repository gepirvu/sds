variable "location" {
  type        = string
  description = "The default location where the Static App will be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

variable "umids_names" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity names to assign to the App Configuration. Changing this forces a new resource to be created."
  default     = []
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet where the private endpoint will be created"
}

variable "public_subnet_name" {
  type        = string
  description = "The name of the public subnet"

}

variable "private_subnet_name" {
  type        = string
  description = "The name of the private subnet"


}

variable "pe_subnet_name" {
  type        = string
  description = "The name of the subnet where the private endpoint will be created"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault where the keys are stored"

}

variable "frotend_private_access_enabled" {
  type        = bool
  description = "Should the front be private and access via Private Endpoint?"
  default     = false

}

variable "sku" {
  type        = string
  description = "The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial."
  default     = "standard"

}

variable "storage_account_sku_name" {
  type        = string
  description = "Storage account SKU name. Possible values include Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_GZRS, Standard_RAGZRS, Standard_ZRS, Premium_LRS or Premium_ZRS. Defaults to Standard_GRS."
  default     = "Standard_LRS"

}

variable "location" {
  type        = string
  description = "The default location wherethe resources will be created"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
  default     = "np"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}


variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "user_managed_identities" {
  description = "(optional) user manage identity Id, requires if 'requires_identity' field set to true"
  type        = list(any)
}

variable "service_plan_usage" {
  type        = string
  description = "Short description to identify or diferentiate your App services plans"
}

variable "service_plan_sku_name" {
  type        = string
  description = "The SKU for the plan. Possible values include B1, I3, P1v2"
}

variable "service_plan_os_type" {
  type        = string
  description = "Type of the for the App Service Plan i.e Windows, Linux"
}


variable "logic_app_storage_account_name" {
  type        = string
  description = ""
}

variable "logic_app_storage_account_key" {
  type        = string
  description = ""
}

variable "virtual_network_subnet_id" {
  type        = string
  description = ""
}

variable "vnet_pe_id" {
  type        = string
  description = "Incoming subnet configuration for Private endpoint"
}


variable "logic_app" {
  description = "Short description for the usage of the logicapp"
  type = list(object({
    logic_app_description = string
    requires_identity     = bool

  }))
}


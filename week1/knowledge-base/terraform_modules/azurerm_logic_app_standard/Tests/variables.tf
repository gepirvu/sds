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

variable "user_assigned_identity_name" {
  type        = string
  description = "The name of your UMI"
}

variable "resource_group_name" {
  type        = string
  description = "The name of your RG"
}

variable "logic_app_storage_account_name" {
  type        = string
  description = "Name to store configuration of the Logic Apps"
}


variable "vint_subnet_name" {
  type    = string
  default = "Subnet name for Integrating in LogicApss"
}

variable "pe_subnet_name" {
  type    = string
  default = "Subnet name for Private endpoints"
}


variable "service_plan_sku_name" {
  type        = string
  description = "The SKU for the plan. Possible values include B1, I3, P1v2"
}

variable "service_plan_usage" {
  type        = string
  description = "Short description to identify or diferentiate your App services plans"
}

variable "service_plan_os_type" {
  type        = string
  default     = "Windows"
  description = "Type of the for the App Service Plan i.e Windows, Linux"
}


variable "logic_app" {
  description = "Short description for the usage of the logicapp"
  type = list(object({
    logic_app_description = string
    requires_identity     = bool

  }))
}

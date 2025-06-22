
variable "location" {
  type        = string
  description = "The default location where the log analytics will be created"
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


variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "sku_law" {
  type        = string
  default     = "PerGB2018"
  description = "Pricing tier of Log Analytics Workspace"
}

variable "retention_in_days_law" {
  type        = number
  default     = 30
  description = "The Log Analytics Workspace data retention in days. Possible values range between 30 and 730."

}

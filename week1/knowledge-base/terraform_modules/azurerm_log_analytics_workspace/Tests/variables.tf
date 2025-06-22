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

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds' "
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "retention_in_days_law" {
  type        = number
  default     = 30
  description = "The Log Analytics Workspace data retention in days. Possible values range between 30 and 730."

}

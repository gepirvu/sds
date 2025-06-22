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

variable "logic_app" {
  description = "Short description for the usage of the logicapp"
  type = list(object({
    logic_app_description = string
    requires_identity     = bool

  }))
}

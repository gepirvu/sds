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

variable "user_assigned_identity_name" {
  type        = string
  description = "The name of your UMI"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "requires_identity" {
  type        = bool
  description = "In case identity is needed please type 'true' or 'false'"
}

variable "logic_app_description" {
  type        = string
  description = "The short description of the Logc App to create"
}

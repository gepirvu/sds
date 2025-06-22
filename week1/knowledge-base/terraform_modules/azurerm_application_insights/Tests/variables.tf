
variable "location" {
  type        = string
  description = "Specifies azure region/location where resources will be created."
}
variable "resource_group_name" {
  type        = string
  description = "The name of the existing resource group to create the Application insights"
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


variable "application_type" {
  type        = string
  description = "The type of application insight you want to deploy"
}

variable "log_analytics_workspace_name" {
  type        = string
  default     = null
  description = "Log application workspace name to link between insights and log analytics workspace"
}


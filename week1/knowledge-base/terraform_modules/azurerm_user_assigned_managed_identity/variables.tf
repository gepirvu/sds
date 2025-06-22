variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the user assigned identity."
}

variable "location" {
  type        = string
  description = "The location/region where the user assigned identity is created."
}

variable "umid_name" {
  type        = list(string)
  description = "What is the name for the managed identity?."
}


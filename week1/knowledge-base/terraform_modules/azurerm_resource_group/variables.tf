variable "project_name" {
  type        = string
  description = "The name of the project. e.g. DYOS"
  default     = "dyos"
}

variable "subscription" {
  type        = string
  description = "The subscription type (prod or nonprod) e.g. 'p' or 'np'"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The location/region where the resource group will be created."
  default     = "westeurope"
}

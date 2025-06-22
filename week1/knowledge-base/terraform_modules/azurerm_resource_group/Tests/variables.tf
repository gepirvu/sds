variable "location" {
  type        = string
  description = "The location/region where the resource group will be created."
  default     = "westeurope"
}

variable "resource_groups" {
  type = list(object({
    subscription = string
    project_name = string
    environment  = string
  }))
  description = "The configuration of the resource groups to be created"
  default = [
    {
      subscription = "np"
      project_name = "dyos"
      environment  = "dev"
    },
    {
      subscription = "np"
      project_name = "dyos"
      environment  = "qa"
    },
    {
      subscription = "np"
      project_name = "dyos"
      environment  = "uat"
    },
    {
      subscription = "p"
      project_name = "dyos"
      environment  = "prod"
    }
  ]
}
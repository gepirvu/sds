#------------------------------------------------------------------------------------------------------------------#
# Generic
#------------------------------------------------------------------------------------------------------------------#

variable "location" {
  description = "The location/region where the resource group will be created."
  default     = "westeurope"
}

#------------------------------------------------------------------------------------------------------------------#
# Existing 
#------------------------------------------------------------------------------------------------------------------#

variable "resource_group_name" {
  type        = string
  description = "Specifies the Resource Group that contains Network Security Groups(NSGs) to be configured/administered"
  default     = "rg-where-nsgs-are-located"
  nullable    = false
}

variable "network_security_groups" {
  type        = list(string)
  description = "List of network security groups to apply rules to."
}

#------------------------------------------------------------------------------------------------------------------#

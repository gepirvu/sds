# Purpose: Define the min required version of Terraform and the min required version of the providers to use in the configuration (Add additional providers if needed).
terraform {
  required_version = ">= 1.8.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
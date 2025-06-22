terraform {
  required_version = ">= 1.8.0"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 4.0"
      configuration_aliases = [azurerm.dns]

    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
  }
}
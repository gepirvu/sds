terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.8.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azuread" {}
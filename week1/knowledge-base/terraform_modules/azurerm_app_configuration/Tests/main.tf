terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "= 0.12.1"
    }
  }
}

provider "azurerm" {
  features {
    app_configuration {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = false
    }
  }
  resource_provider_registrations = "none"
}

provider "azuread" {}

provider "time" {}


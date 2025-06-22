terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}

provider "azuread" {}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azurerm" {
  alias           = "dns"
  subscription_id = "36cae50e-ce2a-438f-bd97-216b7f682c77"
  features {}
}

terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.8.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias           = "dns"
  subscription_id = var.dns_sub_id
  features {}
  skip_provider_registration = true
}
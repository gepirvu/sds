
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azuread" {}

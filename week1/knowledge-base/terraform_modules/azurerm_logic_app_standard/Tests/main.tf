terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  #storage_use_azuread        = true
  use_msi = true
}

provider "azuread" {}

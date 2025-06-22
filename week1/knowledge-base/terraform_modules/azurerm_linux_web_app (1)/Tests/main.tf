terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "dns"
  subscription_id = "36cae50e-ce2a-438f-bd97-216b7f682c77"
  features {}
}

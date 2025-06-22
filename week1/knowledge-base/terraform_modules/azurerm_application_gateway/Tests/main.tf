terraform {
  backend "azurerm" {}

  required_providers {
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "0.2.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  resource_provider_registrations = "none"
}

provider "tls" {}
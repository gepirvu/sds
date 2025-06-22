# Example of defining the input variables for the module to test
# -------------------------------------------------------------#

# General

resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"
project_name        = "cloudinfra"
subscription        = "np"
environment         = "dev"

# App Service Plan

sku_name               = "P1v2"
zone_balancing_enabled = false
worker_count           = 1

# Function App

storage_account_name                = "axso4p4ssp4np4testsa"
storage_account_resource_group_name = "axso-np-appl-ssp-test-rg"
https_only                          = true
public_network_access_enabled       = false
vnet_integration_subnet_name        = "app-windows-subnet"

function_app = [
  {
    usecase = "java"
  },
  {
    usecase = "script"
  }
]

# Private Endpoint

pe_subnet_name              = "pe"
network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
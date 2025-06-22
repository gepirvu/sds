#===========================================================================================================================================#
# General                                                                                                                                   #
#===========================================================================================================================================#

project_name = "cloudinfra"

subscription = "np"

environment = "test"

resource_group_name = "axso-np-appl-ssp-test-rg"

location = "westeurope"

#===========================================================================================================================================#
# Container registry                                                                                                                        #
#===========================================================================================================================================#
admin_enabled = false

retention_policy_in_days = 7

data_endpoint_enabled = true

identity_type = "SystemAssigned, UserAssigned" # "SystemAssigned"  "SystemAssigned" or "UserAssigned" or "SystemAssigned, UserAssigned"

acr_umids = [
  {
    umid_name    = "axso-np-appl-ssp-test-umid"
    umid_rg_name = "axso-np-appl-ssp-test-rg"
  }
]

pe_subnet = {
  subnet_name  = "pe"
  vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
  vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
}

acr_allowed_subnets = {
  "subnet-1" = {
    subnet_name  = "compute"
    vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
    vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
  },
  "subnet-2" = {
    subnet_name  = "aks"
    vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
    vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
  }
}

georeplications_configuration = [
  {
    location                = "North Europe" # The georeplications list cannot contain the location where the Container Registry exists.
    zone_redundancy_enabled = false
  }

  # If more than one georeplications block is specified, they are expected to follow the alphabetic order on the location property.
]

#===========================================================================================================================================#
#-------------------------------------------------------------------------------------------------------------------#
# Prerequisites and general                                                                                         #
#-------------------------------------------------------------------------------------------------------------------#

resource_group_name = "axso-np-appl-ssp-test-rg"

location = "westeurope"

project_name = "ci"

subscription = "np"

environment = "lab"

#-------------------------------------------------------------------------------------------------------------------#
# Redis                                                                                                             #
#-------------------------------------------------------------------------------------------------------------------#

### Redis Cache - Pricing ###

capacity = 1
family   = "C"
sku_name = "Standard"

### Redis Cache - Network ###

# Private Endpoint

pe_subnet_details = {
  subnet_name  = "app-conf-pe-subnet"
  vnet_name    = "vnet-ssp-nonprod-axso-vnet"
  vnet_rg_name = "axso-np-appl-ssp-test-rg"
}

# Firewall Rules

redis_fw_rules = {
  "test-rule-1" = {
    name     = "test_rule_1" # "name" may only contain alphanumeric characters and underscores.
    start_ip = "192.168.1.1"
    end_ip   = "192.168.1.2"
  },
  "test-rule-2" = {
    name     = "test_rule_2" # "name" may only contain alphanumeric characters and underscores.
    start_ip = "192.168.1.3"
    end_ip   = "192.168.1.4"
  }
}

### Redis Cache - Patching ###

enable_patching = true
day_of_week     = "Sunday"
start_hour_utc  = 6

### Redis Cache - Authentication ###

active_directory_authentication_enabled = false # Only applicable for Premium SKU.

access_keys_authentication_enabled = true # Can only be disabled when SKU is Premium and active_directory_authentication_enabled is true.

identity_type = "UserAssigned"

redis_umids = {
  umid-1 = {
    umid_name    = "axso-np-appl-ssp-test-umid"
    umid_rg_name = "axso-np-appl-ssp-test-rg"
  },
  umid-2 = {
    umid_name    = "axso-np-appl-ssp-test-umid2"
    umid_rg_name = "axso-np-appl-ssp-test-rg"
  }
}

#-------------------------------------------------------------------------------------------------------------------#
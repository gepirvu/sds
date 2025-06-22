location                            = "westeurope"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"


subnet_config = [
  {
    subnet_name                                = "uat-db-backend-subnet"
    subnet_address_prefixes                    = ["10.84.167.32/29"]
    default_name_network_security_group_create = true
    custom_name_network_security_group         = ""
    route_table_name                           = "route-spoke-nonprod-axso-xsgh"
    private_endpoint_network_policies_enabled  = "Enabled"
    subnet_service_endpoints                   = ["Microsoft.Sql"]
    subnets_delegation_settings                = {}

  },
  {
    subnet_name                                = "uat-api-frondend-subnet"
    subnet_address_prefixes                    = ["10.84.167.40/29"]
    default_name_network_security_group_create = false
    custom_name_network_security_group         = "nsg-cloudinfra-cloudflarensg-nonprod-axso-9xoj"
    route_table_name                           = "route-spoke-nonprod-axso-xsgh"
    private_endpoint_network_policies_enabled  = "Enabled"
    subnet_service_endpoints                   = []
    subnets_delegation_settings = {
      app-service-plan = [
        {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      ]
    }
  }
]



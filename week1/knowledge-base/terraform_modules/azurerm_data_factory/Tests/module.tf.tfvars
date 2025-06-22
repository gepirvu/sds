resource_group_name                 = "axso-np-appl-ssp-test-rg"
location                            = "westeurope"
project_name                        = "cloudinfra"
subscription                        = "np"
environment                         = "dev"
key_vault_name                      = "kv-ssp-0-nonprod-axso"
identity_type                       = "UserAssigned"
umids_names                         = ["axso-np-appl-ssp-test-umid"]
managed_virtual_network_enabled     = false
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                      = "pe"

global_parameters = [
  {
    name  = "param6"
    type  = "String"
    value = "some string"
  },
  {
    name  = "param7"
    type  = "Int"
    value = "42"
  },
  {
    name  = "param1"
    type  = "Object"
    value = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
  },
  {
    name  = "param2"
    type  = "Array"
    value = "[\"value1\", \"value2\", \"value3\"]"
  }
]

vsts_configuration = null

purview_id = null

azure_integration_runtimes = [
  {
    name                    = "rn1"
    description             = "Integration Runtime 1"
    cleanup_enabled         = true
    compute_type            = "General"
    core_count              = 8
    time_to_live_min        = 0
    virtual_network_enabled = false
  }
]

self_hosted_integration_runtimes = [
  {
    name        = "SelfHostedIntegrationRuntime1"
    description = "Self Hosted Integration Runtime 1"
  }
]

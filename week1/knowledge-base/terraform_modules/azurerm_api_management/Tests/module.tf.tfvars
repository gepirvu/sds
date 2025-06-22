resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
subnet_names                        = ["apim"]
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
nsg_name                            = "ssp-nonprod-axso-apim-nsg"
virtual_network_type                = "Internal"


sku_name        = "Premium_1"
publisher_name  = "Contoso ApiManager"
publisher_email = "api_manager@test.com"
zones           = []
key_vault_name  = "kv-ssp-0-nonprod-axso"

named_values = [
  {
    display_name = "apim-test-no-keyvault"
    name         = "apim-test-no-kv"
    value        = "my-secret-value"
    secret       = true
  },
  {
    display_name = "my-second-value"
    name         = "my-second-value"
    value        = "my-not-secret-value"
  }
]

keyvault_named_values = [
  {
    display_name = "apim-test-keyvault"
    name         = "apim-test-kv"
    value        = "apim-test" # Keyvault "secret name" that contains the secret value
    secret       = true
  }
]



app_insights_name = "axso-np-appl-ssp-dev-insights"
backend_protocol  = "http"
backend_services = [
  "admin-services-as",
  "user-services-as"
]

requires_custom_host_name_configuration = false #If custom names are needed. First set to false in first pipeline execution, then to true and run pipeline again
#wildcard_certificate_key_vault_name                = "kv-ssp-0-nonprod-axso" #make sure the certs are in this kv 
#wildcard_certificate_name                          = "nonprod-cloudinfra-axpo-cloud"
#wildcard_certificate_key_vault_resource_group_name = "axso-np-appl-ssp-test-rg"
#developer_portal_host_name                         = "developer.nonprod.cloudinfra.axpo.cloud"
#management_host_name                               = "management.nonprod.cloudinfra.axpo.cloud"
#gateway_host_name                                  = "api.nonprod.cloudinfra.axpo.cloud"
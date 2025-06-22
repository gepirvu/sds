#-----------------------------------------------------------------------------------------------------------------#
# General                                                                                                         #
#-----------------------------------------------------------------------------------------------------------------#
resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"
key_vault_name      = "kv-ssp-0-nonprod-axso"

#-----------------------------------------------------------------------------------------------------------------#
# App configuration and app config keys                                                                           #
#-----------------------------------------------------------------------------------------------------------------#

app_conf = [
  {
    # Naming convention
    project_name = "cloudinfra"
    subscription = "np"
    environment  = "dv"

    # Standard settings
    sku                        = "standard"
    local_auth_enabled         = false
    purge_protection_enabled   = false
    soft_delete_retention_days = 7
    identity_type              = "UserAssigned"
    public_network_access      = "Enabled"


    pe_subnet = {
      subnet_name  = "pe"
      vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
      vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
    }

    # App config keys
    app_conf_key   = "app-key-1"
    app_conf_label = "app-key-1"
    app_conf_value = [
      {
        "ts_calc_server" : "AzureSmallJobs",
        "pool_id" : "axso-np-ts-uat-azure-small-batch-pool"
      },
      {
        "ts_calc_server" : "AzureLargeJobs",
        "pool_id" : "axso-np-ts-uat-azure-large-batch-pool"
      }
    ]
  }
]



app_conf_umids_names = ["axso-np-appl-ssp-test-umid"] # User Assigned Managed that will be assign to the App Configuration

app_conf_client_access_umids = ["bf28a8c4-21ac-41cf-9eeb-1d34d07c8bad"] # It is the same that above but for testing purposes. This should be the ID of the app service for example

#-----------------------------------------------------------------------------------------------------------------#
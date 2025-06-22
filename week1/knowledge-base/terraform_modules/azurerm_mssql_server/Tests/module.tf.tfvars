resource_group_name         = "axso-np-appl-ssp-test-rg"
network_resource_group_name = "axso-np-appl-ssp-test-rg"
virtual_network_name        = "vnet-ssp-nonprod-axso-vnet"
mssql_subnet_name           = "mssql-subnet"
storage_account_name        = "axso4p4ssp4np4testsa"
key_vault_name              = "kv-ssp-0-nonprod-axso"


location                                              = "West Europe"
environment                                           = "dev"
project_name                                          = "ssp"
subscription                                          = "np"
server_version                                        = "12.0"
login_username                                        = "sqladmin"
email_accounts                                        = ["marcel.lupo@axpo.com"]
mssql_administrator_group                             = "testaaa"
azuread_authentication_only                           = true
threat_detection_policy                               = "Disabled"
azurerm_mssql_server_vulnerability_assessment_enabled = false

create_elastic_pool = true
elastic_pool_config = {
  name                = "test-elasticpool"
  max_size_gb         = 50
  sku_name            = "PremiumPool"
  sku_tier            = "Premium"
  zone_redundant      = true
  sku_family          = null
  sku_capacity        = 125
  per_db_min_capacity = 0
  per_db_max_capacity = 25
}

mssql_databases = [
  {
    create_db                   = true
    db_name                     = "test-ssp-stand-alone-db"
    attach_to_elasticpool       = false
    collation                   = "SQL_Latin1_General_CP1_CI_AS"
    create_mode                 = "Default"
    max_size_gb                 = 250
    min_capacity                = 1
    sku_name                    = "P2"
    storage_account_type        = "Zone"
    zone_redundant              = true
    auto_pause_delay_in_minutes = 10
    short_term_retention_days   = 7
    ltr_weekly_retention        = "P7D"
  },
  {
    create_db                   = false
    db_name                     = "test-elastic-attached-db1"
    attach_to_elasticpool       = true
    collation                   = "SQL_Latin1_General_CP1_CI_AS"
    create_mode                 = "Default"
    max_size_gb                 = null
    min_capacity                = null
    sku_name                    = "ElasticPool"
    storage_account_type        = "Zone"
    zone_redundant              = true
    auto_pause_delay_in_minutes = null
    short_term_retention_days   = 7
    ltr_weekly_retention        = "P7D"
  }
]
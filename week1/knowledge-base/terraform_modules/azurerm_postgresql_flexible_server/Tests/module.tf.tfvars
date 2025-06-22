# Common

resource_group_name = "axso-np-appl-ssp-test-rg"

location = "westeurope"

# PostgreSQL flexible server

# Naming convention for PostgreSQL flexible server
project_name = "cloudinfra"
subscription = "np"
environment  = "dev"

# PostgreSQL flexible server
pgsql_version     = "15"
sku_name          = "GP_Standard_D2ds_v5"
storage_mb        = 32768 # 32GB
storage_tier      = "P4"
auto_grow_enabled = false

# Network configuration
vnet_integration_enable = true
psql_subnet_name        = "psql" # If vnet_integration_enable = false, this will be the name of the PE subnet
virtual_network_name    = "vnet-cloudinfra-nonprod-axso-e3og"
virtual_network_rg      = "rg-cloudinfra-nonprod-axso-ymiw"

# Authentication configuration
password_auth_enabled          = true #Blocked by policy
route_table_name               = "route-spoke-nonprod-axso-xsgh"
active_directory_auth_enabled  = true
keyvault_name                  = "kv-ssp-0-nonprod-axso"
keyvault_resource_group_name   = "axso-np-appl-ssp-test-rg"
postgresql_administrator_group = "testaaa"
identity_type                  = "UserAssigned"
identity_names                 = ["axso-np-appl-ssp-test-umid"]

# High availability configuration
high_availability_required = false
high_availability_mode     = "ZoneRedundant" # when high_availability_required = true


# PostgreSQL flexible server - Database

postgresql_flexible_server_databases = {
  db1 = {
    database_name = "db1"
  }
}

#Backup configuration
geo_redundant_backup_enabled = true
backup_retention_days        = 7
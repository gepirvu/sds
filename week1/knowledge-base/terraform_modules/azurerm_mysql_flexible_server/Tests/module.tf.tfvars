# Generic

resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"
project_name        = "cloudinfra"
subscription        = "np"
environment         = "dev"

# MySQL configuration

mysql_version                = "8.0.21"
sku_name                     = "GP_Standard_D2ds_v4"
geo_redundant_backup_enabled = false

storage = {
  auto_grow_enabled  = true
  io_scaling_enabled = false
  iops               = 360
  size_gb            = 20
}

databases = {
  "documents" = {
    charset   = "utf8mb3"
    collation = "utf8mb3_general_ci"
  }
}

maintenance_window = {
  day_of_week  = 0
  start_hour   = 0
  start_minute = 0
}

delegated_subnet_details = {
  vnet_rg_name = "axso-np-appl-ssp-test-rg"
  vnet_name    = "vnet-ssp-nonprod-axso-vnet"
  subnet_name  = "mysql-subnet"
}

allowed_cidrs = {
  "onprem" = "10.0.0.0/24"
}

# Authentication
administrator_login            = "sqladmin"
mysql_aad_group                = null                         # Mention the AAD group name if you want to enable AAD authentication
umid_name                      = "axso-np-appl-ssp-test-umid" # can be empty string "" if not needed
admin_password_expiration_date = "2025-12-06T02:03:00Z"
key_vault_name                 = "kv-ssp-0-nonprod-axso"

mysql_options = {
  audit_log_enabled = "ON"
}

high_availability_mode = {
  mode = "SameZone"
}
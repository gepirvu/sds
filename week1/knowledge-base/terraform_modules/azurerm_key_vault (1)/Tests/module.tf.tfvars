environment         = "dev"
project_name        = "prj"
location            = "westeurope"
resource_group_name = "axso-np-appl-ssp-test-rg"
kv_number           = "001"

sku_name                        = "standard"
enabled_for_deployment          = true
enabled_for_disk_encryption     = true
enabled_for_template_deployment = true

admin_groups  = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]
reader_groups = ["CL-AZ-SUBS-cloudinfra-nonprod-Reader"]

virtual_network_name          = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                = "pe"
network_resource_group_name   = "rg-cloudinfra-nonprod-axso-ymiw"
public_network_access_enabled = false

log_analytics_workspace_name = "axso-np-appl-cloudinfra-dev-loga"
expire_notification          = true
email_receiver               = ["mario.martinezdiez@axpo.com", "2a8e6d57.axpogrp.onmicrosoft.com@ch.teams.ms"] #Teams channel email

# Specify Network ACLs
network_acls = {
  bypass         = "AzureServices"
  default_action = "Deny"
  ip_rules       = []

  virtual_network_subnet_ids = []
}
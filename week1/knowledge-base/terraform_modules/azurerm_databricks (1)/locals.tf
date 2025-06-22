locals {
  days_to_hours = 365 * 24
  // expiration date need to be in a specific format as well
  expiration_date = timeadd(formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp()), "${local.days_to_hours}h")
}

resource "random_string" "cmk_suffix" {
  length      = 4
  upper       = false
  min_numeric = 1
  special     = false
}

locals {
  adbdnsid             = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.azuredatabricks.net"
  blobdnsid            = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  dfsdnsid             = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.dfs.core.windows.net"
  adb_name             = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-adb")
  storage_account_name = "${replace(local.adb_name, "-", "")}dbfs"
  storage_account_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/databricks-rg-${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${local.storage_account_name}"
}
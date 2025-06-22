locals {

  storage_account_name = join("", [
    lower(substr("axso4${var.subscription}4${var.environment}4${var.project_name}", 0, 20)),
    var.storage_account_index
  ])

  private_dns_zone_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink"

}


locals {
  storage_types = concat(
    lookup({
      "StorageV2"        = ["blob", "file", "queue", "table"],
      "BlobStorage"      = ["blob"],
      "BlockBlobStorage" = ["blob"],
      "FileStorage"      = ["file"]
    }, var.account_kind_storage, ["blob"]),
    var.is_hns_enabled ? ["dfs"] : []
  )
}


resource "random_string" "cmk_suffix" {
  length      = 4
  upper       = false
  min_numeric = 1
  special     = false
}

locals {
  days_to_hours = 365 * 24
  // expiration date need to be in a specific format as well
  expiration_date = timeadd(formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp()), "${local.days_to_hours}h")
}

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
  type = {
    for cosmosdb_account in var.cosmosdb_accounts : cosmosdb_account.name => {
      kind = lookup({
        "nosql"     = "GlobalDocumentDB",
        "mongo"     = "MongoDB",
        "cassandra" = "GlobalDocumentDB",
        "gremlin"   = "GlobalDocumentDB",
        "table"     = "GlobalDocumentDB"
      }, cosmosdb_account.cosmosdb_type, "MongoDB")
    }
  }
}




locals {
  dns_zones = {
    for cosmosdb_account in var.cosmosdb_accounts : cosmosdb_account.name => {
      dns_zone = lookup({
        "nosql"     = "privatelink.documents.azure.com",
        "mongo"     = "privatelink.mongo.cosmos.azure.com",
        "cassandra" = "privatelink.cassandra.cosmos.azure.com",
        "gremlin"   = "privatelink.gremlin.cosmos.azure.com",
        "table"     = "privatelink.table.cosmos.azure.com"
      }, cosmosdb_account.cosmosdb_type, "privatelink.mongo.cosmos.azure.com")
    }
  }

  subresource_names = {
    for cosmosdb_account in var.cosmosdb_accounts : cosmosdb_account.name => {
      subresource_name = lookup({
        "nosql"     = "Sql",
        "mongo"     = "MongoDB",
        "cassandra" = "Cassandra",
        "gremlin"   = "Gremlin",
        "table"     = "Table"
      }, cosmosdb_account.cosmosdb_type, "MongoDB")
    }
  }

  psqldnsid = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.cosmos.azure.com"
}

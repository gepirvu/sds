location                            = "West Europe"
environment                         = "dev"
project_name                        = "ssp"
subscription                        = "np"
resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                      = "pe-2"
key_vault_name                      = "kv-ssp-0-nonprod-axso"
identity_type                       = "UserAssigned"
umids_names = [
  "axso-np-appl-ssp-test-umid"
]



cosmosdb_accounts = [
  # Please, review README to understand all the values
  {
    name                       = "mgdb"
    cosmosdb_type              = "mongo"
    free_tier_enabled          = true
    analytical_storage_enabled = false
    burst_capacity_enabled     = true
    mongo_server_version       = "4.0"

    consistency_policy = [
      {
        name                    = "1regionwrite-multiple-reads"
        consistency_level       = "BoundedStaleness"
        max_interval_in_seconds = 300
        max_staleness_prefix    = 100000
      }
    ]

    geo_location = [
      {
        location          = "West Europe"
        failover_priority = 0 #Write region
        zone_redundant    = true
      },
      {
        location          = "Germany West Central"
        failover_priority = 1
        zone_redundant    = false
      },
      {
        location          = "Switzerland North"
        failover_priority = 2
        zone_redundant    = false
      }
    ]

    capabilities = [
      { name = "EnableMongo" },
      { name = "MongoDBv3.4" }
    ]

    analytical_storage = []

    capacity = [
      { total_throughput_limit = 1000 }
    ]

    backup = [
      {
        name = "my-backup"
        type = "Continuous"
        tier = "Continuous7Days"
      }
    ]

    cors_rule = [
      {
        name               = "my-cors-rule"
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["*"]
        exposed_headers    = ["x-ms-meta-*"]
        max_age_in_seconds = 3600
      }
    ]
  },
  {
    name                       = "opendoc"
    cosmosdb_type              = "nosql"
    free_tier_enabled          = false #Maximum 1 free tier per sub
    analytical_storage_enabled = false
    burst_capacity_enabled     = true

    consistency_policy = [
      {
        name                    = "1regionwrite-multiple-reads"
        consistency_level       = "BoundedStaleness"
        max_interval_in_seconds = 300
        max_staleness_prefix    = 100000
      }
    ]

    geo_location = [
      {
        location          = "West Europe"
        failover_priority = 0 #Write region
        zone_redundant    = true
      },
      {
        location          = "Germany West Central"
        failover_priority = 1
        zone_redundant    = false
      },
      {
        location          = "Switzerland North"
        failover_priority = 2
        zone_redundant    = false
      }
    ]

    capabilities = []

    analytical_storage = []

    capacity = [
      { total_throughput_limit = 1000 }
    ]

    backup = [
      {
        name = "my-backup"
        type = "Continuous"
        tier = "Continuous7Days"
      }
    ]

    cors_rule = [
      {
        name               = "my-cors-rule"
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["*"]
        exposed_headers    = ["x-ms-meta-*"]
        max_age_in_seconds = 3600
      }
    ]
  },
  {
    name                       = "csndra"
    cosmosdb_type              = "cassandra"
    free_tier_enabled          = false #Maximum 1 free tier per sub
    analytical_storage_enabled = false
    burst_capacity_enabled     = true

    consistency_policy = [
      {
        name                    = "1regionwrite-multiple-reads"
        consistency_level       = "BoundedStaleness"
        max_interval_in_seconds = 300
        max_staleness_prefix    = 100000
      }
    ]

    geo_location = [
      {
        location          = "West Europe"
        failover_priority = 0 #Write region
        zone_redundant    = true
      },
      {
        location          = "Germany West Central"
        failover_priority = 1
        zone_redundant    = false
      },
      {
        location          = "Switzerland North"
        failover_priority = 2
        zone_redundant    = false
      }
    ]

    capabilities = [

      { name = "EnableCassandra" }
    ]

    analytical_storage = []

    capacity = [
      { total_throughput_limit = 1000 }
    ]

    backup = [
      {
        name                = "my-backup"
        type                = "Periodic"
        interval_in_minutes = "60"
        retention_in_hours  = "72"
        storage_redundancy  = "Local"
      }
    ]

    cors_rule = [
      {
        name               = "my-cors-rule"
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["*"]
        exposed_headers    = ["x-ms-meta-*"]
        max_age_in_seconds = 3600
      }
    ]
  },
  {
    name                       = "grmln"
    cosmosdb_type              = "gremlin"
    free_tier_enabled          = false #Maximum 1 free tier per sub
    analytical_storage_enabled = false
    burst_capacity_enabled     = true

    consistency_policy = [
      {
        name                    = "1regionwrite-multiple-reads"
        consistency_level       = "BoundedStaleness"
        max_interval_in_seconds = 300
        max_staleness_prefix    = 100000
      }
    ]

    geo_location = [
      {
        location          = "West Europe"
        failover_priority = 0 #Write region
        zone_redundant    = true
      },
      {
        location          = "Germany West Central"
        failover_priority = 1
        zone_redundant    = false
      },
      {
        location          = "Switzerland North"
        failover_priority = 2
        zone_redundant    = false
      }
    ]

    capabilities = [

      { name = "EnableGremlin" }
    ]

    analytical_storage = []

    capacity = [
      { total_throughput_limit = 1000 }
    ]

    backup = [
      {
        name                = "my-backup"
        type                = "Periodic"
        interval_in_minutes = "60"
        retention_in_hours  = "72"
        storage_redundancy  = "Local"
      }
    ]

    cors_rule = [
      {
        name               = "my-cors-rule"
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["*"]
        exposed_headers    = ["x-ms-meta-*"]
        max_age_in_seconds = 3600
      }
    ]
  },
  {
    name                       = "tbl"
    cosmosdb_type              = "table"
    free_tier_enabled          = false #Maximum 1 free tier per sub
    analytical_storage_enabled = false
    burst_capacity_enabled     = true

    consistency_policy = [
      {
        name                    = "1regionwrite-multiple-reads"
        consistency_level       = "BoundedStaleness"
        max_interval_in_seconds = 300
        max_staleness_prefix    = 100000
      }
    ]

    geo_location = [
      {
        location          = "West Europe"
        failover_priority = 0 #Write region
        zone_redundant    = true
      },
      {
        location          = "Germany West Central"
        failover_priority = 1
        zone_redundant    = false
      },
      {
        location          = "Switzerland North"
        failover_priority = 2
        zone_redundant    = false
      }
    ]

    capabilities = [

      { name = "EnableTable" }
    ]

    analytical_storage = []

    capacity = [
      { total_throughput_limit = 1000 }
    ]

    backup = [
      {
        name                = "my-backup"
        type                = "Periodic"
        interval_in_minutes = "60"
        retention_in_hours  = "72"
        storage_redundancy  = "Local"
      }
    ]

    cors_rule = [
      {
        name               = "my-cors-rule"
        allowed_headers    = ["*"]
        allowed_methods    = ["GET", "POST"]
        allowed_origins    = ["*"]
        exposed_headers    = ["x-ms-meta-*"]
        max_age_in_seconds = 3600
      }
    ]
  }
]

cosmosdb_postgres = [
  {
    name                            = "psql1"
    sql_version                     = "16"
    node_count                      = 0
    citus_version                   = "12.1"
    coordinator_server_edition      = "GeneralPurpose"
    coordinator_storage_quota_in_mb = 131072
    coordinator_vcore_count         = 4
    node_server_edition             = "GeneralPurpose"
    node_storage_quota_in_mb        = null
    node_vcore_count                = 2
    ha_enabled                      = true
    maintenance_window = {
      day_of_week  = 6
      start_hour   = 3
      start_minute = 0
    }
  }
]

### App Services - General ###
variable "location" {
  type        = string
  description = "The default location where the Static App will be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

variable "umids_names" {
  type        = list(string)
  description = "(Optional) The list of User Assigned Managed Identity names to assign to the App Configuration. Changing this forces a new resource to be created."
  default     = []
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet where the private endpoint will be created"
}

variable "pe_subnet_name" {
  type        = string
  description = "The name of the subnet where the private endpoint will be created"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault where the keys are stored"

}

variable "default_identity_type" {
  type        = string
  description = "The default identity for accessing Key Vault. Possible values are FirstPartyIdentity, SystemAssignedIdentity or UserAssignedIdentity. Defaults to UserAssignedIdentity"
  default     = "UserAssignedIdentity"

}

variable "cosmosdb_accounts" {
  type = list(object({
    name                       = string
    cosmosdb_type              = string # Add cosmosdb_type here
    free_tier_enabled          = bool
    analytical_storage_enabled = bool
    burst_capacity_enabled     = bool
    mongo_server_version       = optional(string)
    consistency_policy = list(object({
      name                    = string
      consistency_level       = optional(string)
      max_interval_in_seconds = optional(number)
      max_staleness_prefix    = optional(number)
    }))
    geo_location = list(object({
      location          = string
      failover_priority = number
      zone_redundant    = bool
    }))
    capabilities = list(object({
      name = string
    }))
    analytical_storage = list(object({
      schema_type = string
    }))
    capacity = list(object({
      total_throughput_limit = number
    }))
    backup = list(object({
      name                = string
      type                = string
      tier                = optional(string)
      interval_in_minutes = optional(number)
      retention_in_hours  = optional(number)
      storage_redundancy  = optional(string)
    }))
    cors_rule = list(object({
      name               = string
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = optional(number)
    }))
  }))

  validation {
    condition     = alltrue([for cosmodb in var.cosmosdb_accounts : contains(["nosql", "mongo", "cassandra", "gremlin", "table", "psql"], cosmodb.cosmosdb_type)])
    error_message = "Each cosmosdb_type must be one of 'nosql', 'mongo', 'cassandra', 'gremlin', 'table', or 'psql'."
  }
  default = null

  description = <<-DESCRIPTION
    A list of configurations for Cosmos DB accounts, supporting various API types like NoSQL, MongoDB, Cassandra, Gremlin, Table, and PostgreSQL.

    - **name**: The name of the Cosmos DB account, used to uniquely identify the account.
    - **cosmosdb_type**: Specifies the type of Cosmos DB account, such as 'nosql', 'mongo', 'cassandra', 'gremlin'or 'table'
    - **free_tier_enabled**: Enables or disables free-tier options for the account. When enabled, the account has certain cost savings. Max 1 free-tier account per subscription.
    - **analytical_storage_enabled**: Defines whether the account has analytical storage capabilities, useful for advanced data querying.
    - **burst_capacity_enabled**: Allows the account to automatically handle traffic spikes without manually scaling throughput.
    - **mongo_server_version**: Specifies the MongoDB version if the account uses the MongoDB API. Optional and applicable only for MongoDB.
    - **consistency_policy**: Configures the account's consistency model such as BoundedStaleness, Eventual, Session, Strong  or ConsistentPrefix . The BoundedStaleness policy has a mandatory `consistency_level`, `max_interval_in_seconds`, and `max_staleness_prefix`.
    - **geo_location**: A list of objects defining regional settings, such as the `location` (Azure region), `failover_priority` (failover order), and `zone_redundant` (availability zone distribution).
    - **capabilities**: A list of enabled capabilities, such as advanced features like multi-master support or Cassandra API-specific capabilities.
    - **analytical_storage**: Configures the type of analytical storage for fast querying, with the option to specify the `schema_type`.
    - **capacity**: Defines the total throughput capacity for the account, including the read/write throughput limit. This is very helpful for managing costs, as it allows you to scale the throughput according to actual usage, preventing over-provisioning.
    - **backup**: Backup configurations for the account, such as the `name` of the backup policy, `type` (Continuous or Periodic), `interval_in_minutes`, `retention_in_hours`, and `storage_redundancy` options.
      You can only configure interval_in_minutes, retention_in_hours and storage_redundancy when the type field is set to Periodic.    
    - **cors_rule**: Specifies Cross-Origin Resource Sharing (CORS) rules, including allowed headers, methods, origins, and optional `max_age_in_seconds` for caching purposes.

  DESCRIPTION


}

variable "cosmosdb_postgres" {
  type = list(object({
    name                            = string
    sql_version                     = optional(string)
    node_count                      = number
    node_vcores                     = optional(number)
    citus_version                   = optional(string)
    coordinator_server_edition      = optional(string, "GeneralPurpose")
    coordinator_storage_quota_in_mb = optional(number)
    coordinator_vcore_count         = optional(number)
    node_server_edition             = optional(string, "MemoryOptimized")
    node_storage_quota_in_mb        = optional(number)
    ha_enabled                      = optional(bool, true)
    maintenance_window = optional(object({
      day_of_week  = optional(number)
      start_hour   = optional(number)
      start_minute = optional(number)
    }))
  }))
  default     = null
  description = <<-DESCRIPTION
        Configuration for Cosmos DB PostgreSQL clusters.

        - **name**: The name of the PostgreSQL cluster. This is a unique identifier for the cluster within the resource group.
        - **sql_version**: The major PostgreSQL version on the Azure Cosmos DB for PostgreSQL cluster. Possible values are 11, 12, 13, 14, 15 and 16.
        - **node_count**: (Required) The worker node count of the Azure Cosmos DB for PostgreSQL Cluster. Possible value is between 0 and 20 except 1.
        - **node_vcores**: (Optional) The vCores count on each worker node. Possible values are 1, 2, 4, 8, 16, 32, 64, 96 and 104.
        - **citus_version**: (Optional) The citus extension version on the Azure Cosmos DB for PostgreSQL Cluster. Possible values are 8.3, 9.0, 9.1, 9.2, 9.3, 9.4, 9.5, 10.0, 10.1, 10.2, 11.0, 11.1, 11.2, 11.3 and 12.1.
        - **coordinator_server_edition**: (Optional) The edition of the coordinator server. Possible values are BurstableGeneralPurpose, BurstableMemoryOptimized, GeneralPurpose and MemoryOptimized. Defaults to GeneralPurpose.
        - **coordinator_storage_quota_in_mb**: (Optional) The storage quota for the coordinator node, specified in megabytes.
        - **coordinator_vcore_count**: (Optional) The coordinator vCore count for the Azure Cosmos DB for PostgreSQL Cluster. Possible values are 1, 2, 4, 8, 16, 32, 64 and 96.
        - **node_server_edition**: (Optional) The edition of the node server. Possible values are BurstableGeneralPurpose, BurstableMemoryOptimized, GeneralPurpose and MemoryOptimized. Defaults to MemoryOptimized
        - **node_storage_quota_in_mb**: (Optional) The storage quota in MB on each worker node. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608 and 16777216.
        - **ha_enabled**: (Optional) Is high availability enabled for the Azure Cosmos DB for PostgreSQL cluster? Defaults to true.
        - **maintenance_window**: (Optional) Specifies the maintenance window for the cluster. Includes:
          - **day_of_week**: Day of the week to perform maintenance (0 for Sunday, 6 for Saturday).
          - **start_hour**: Hour at which maintenance should begin (in 24-hour format).
          - **start_minute**: Minute of the hour to begin maintenance.
  DESCRIPTION

}



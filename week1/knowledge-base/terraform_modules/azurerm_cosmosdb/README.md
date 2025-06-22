| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|----------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_cosmosdb?repoName=azurerm_cosmosdb&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=3751&repoName=azurerm_cosmosdb&branchName=main) | **v1.0.5** | **27/02/2025** |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [CosmosDB Configuration](#cosmosdb-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# CosmosDB Configuration

----------------------------

[Learn more about CosmosDBs in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------
>**:warning:**
> **Azure CosmosDB could be a very expensive resource if it is configured improperly.** Please review the following documentation to understand it and what you need to configure it correctly.

<br />

Azure Cosmos DB simplifies and accelerates application development by serving as a single database for operational data needs, from geo-replicated distributed caching to backup and vector indexing. It supports modern applications like AI agents, digital commerce, IoT, and booking management, and accommodates various data models such as relational, document, vector, key-value, graph, and table.

This module deploys an Azure CosmosDB account of the specified type. To select the appropriate API for your application, review [Choose an API in Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/choose-api).

In this module, you can define various configurations for your database. Please review the following key options:

- **Consistency_policy**: Configure the default consistency level for your Cosmos DB account. It applies to all databases and containers. For more details, refer to [Consistency Levels in Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels#bounded-staleness-consistency).  
- **Geo_location**: CosmosDB supports various location and replication setups, from single write/read regions to multi-region with availability zones. Learn more in [High Availability in Azure Cosmos DB for NoSQL](https://learn.microsoft.com/en-us/azure/reliability/reliability-cosmos-db-nosql).  
- **Capabilities**: Add various capabilities to your Cosmos DB account. For details on available capabilities, see [Configure Capabilities in Cosmos DB for MongoDB](https://learn.microsoft.com/en-us/azure/cosmos-db/mongodb/how-to-configure-capabilities).
- **Backup**: Cosmos DB automatically takes regular backups without affecting performance or availability. To explore different backup modes, read [Backup Modes for CosmosDB](https://learn.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore#backup-modes).

## Deployed Resources

----------------------------

The following resources are deployed when using the CosmosDB module:

- azurerm_key_vault_key
- azurerm_cosmosdb_account
- azurerm_private_endpoint
- azurerm_cosmosdb_postgresql_cluster
- azurerm_role_assignment - "Key Vault Crypto Service Encryption User" for umid

## Pre-requisites

----------------

- Resource Group
- Virtual Network for the PE
- Keyvault to store your Keys and secrets

## Axso Naming convention example

---------------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment` and `usecase`:

> Note:
>
>- project_name (First 5 characters will be used for container app environment and container apps)
>- cosmosdb > name (First 5 characters will be used, make sure to use meaningful and unique names)

- **Construct - Cosmosdb:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-cosmos-${name}"`

## Cosmosdb (44 Characters long)

- **NonProd:** `axso-np-appl-cloud-dev-cosmos-opendoc`
- **Prod:** `axso-p-appl-cloud-prod-cosmos-mongo`

# Terraform Files

----------------------------

## module.tf

```hcl

module "cosmosdb" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_cosmosdb?ref=v1.0.5"

  cosmosdb_accounts                   = var.cosmosdb_accounts
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  subscription                        = var.subscription
  project_name                        = var.project_name
  environment                         = var.environment
  identity_type                       = var.identity_type
  default_identity_type               = var.default_identity_type
  umids_names                         = var.umids_names
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  key_vault_name                      = var.key_vault_name
  virtual_network_name                = var.virtual_network_name
  pe_subnet_name                      = var.pe_subnet_name
  cosmosdb_postgres                   = var.cosmosdb_postgres

}

```

## module.tf.tfvars

```hcl

location                            = "West Europe"
environment                         = "dev"
project_name                        = "ssp"
subscription                        = "np"
resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                      = "pe"
key_vault_name                      = "kv-ssp-0-nonprod-axso"
identity_type                       = "UserAssigned"
umids_names = [
  "axso-np-appl-ssp-test-umid"
]



cosmosdb_accounts = [
  # Please, review README to understand all the values
  #COSMODB for MongoDB
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
  #COSMODB for NoSQL
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
  #COSMODB for Cassandra
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
  #COSMODB for Gremlin
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
  #COSMODB for Table
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

#COSMODB for PostgresSQL

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


```

## variables.tf

```hcl

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




```

<!-- BEGIN_TF_DOCS -->
### main.tf

```hcl
terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_account.cosmosdb_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_postgresql_cluster.cosmosdb_postgresql_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_postgresql_cluster) | resource |
| [azurerm_key_vault_key.key_vault_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.password_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.private_endpoint_postgres](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.role_assignment_cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.cmk_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_sleep.rbac_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_service_principal.cosmos_db](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_subnet.pe_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cosmosdb_accounts"></a> [cosmosdb\_accounts](#input\_cosmosdb\_accounts) | A list of configurations for Cosmos DB accounts, supporting various API types like NoSQL, MongoDB, Cassandra, Gremlin, Table, and PostgreSQL.<br/><br/>- **name**: The name of the Cosmos DB account, used to uniquely identify the account.<br/>- **cosmosdb\_type**: Specifies the type of Cosmos DB account, such as 'nosql', 'mongo', 'cassandra', 'gremlin'or 'table'<br/>- **free\_tier\_enabled**: Enables or disables free-tier options for the account. When enabled, the account has certain cost savings. Max 1 free-tier account per subscription.<br/>- **analytical\_storage\_enabled**: Defines whether the account has analytical storage capabilities, useful for advanced data querying.<br/>- **burst\_capacity\_enabled**: Allows the account to automatically handle traffic spikes without manually scaling throughput.<br/>- **mongo\_server\_version**: Specifies the MongoDB version if the account uses the MongoDB API. Optional and applicable only for MongoDB.<br/>- **consistency\_policy**: Configures the account's consistency model such as BoundedStaleness, Eventual, Session, Strong  or ConsistentPrefix . The BoundedStaleness policy has a mandatory `consistency_level`, `max_interval_in_seconds`, and `max_staleness_prefix`.<br/>- **geo\_location**: A list of objects defining regional settings, such as the `location` (Azure region), `failover_priority` (failover order), and `zone_redundant` (availability zone distribution).<br/>- **capabilities**: A list of enabled capabilities, such as advanced features like multi-master support or Cassandra API-specific capabilities.<br/>- **analytical\_storage**: Configures the type of analytical storage for fast querying, with the option to specify the `schema_type`.<br/>- **capacity**: Defines the total throughput capacity for the account, including the read/write throughput limit. This is very helpful for managing costs, as it allows you to scale the throughput according to actual usage, preventing over-provisioning.<br/>- **backup**: Backup configurations for the account, such as the `name` of the backup policy, `type` (Continuous or Periodic), `interval_in_minutes`, `retention_in_hours`, and `storage_redundancy` options.<br/>  You can only configure interval\_in\_minutes, retention\_in\_hours and storage\_redundancy when the type field is set to Periodic.<br/>- **cors\_rule**: Specifies Cross-Origin Resource Sharing (CORS) rules, including allowed headers, methods, origins, and optional `max_age_in_seconds` for caching purposes. | <pre>list(object({<br/>    name                       = string<br/>    cosmosdb_type              = string # Add cosmosdb_type here<br/>    free_tier_enabled          = bool<br/>    analytical_storage_enabled = bool<br/>    burst_capacity_enabled     = bool<br/>    mongo_server_version       = optional(string)<br/>    consistency_policy = list(object({<br/>      name                    = string<br/>      consistency_level       = optional(string)<br/>      max_interval_in_seconds = optional(number)<br/>      max_staleness_prefix    = optional(number)<br/>    }))<br/>    geo_location = list(object({<br/>      location          = string<br/>      failover_priority = number<br/>      zone_redundant    = bool<br/>    }))<br/>    capabilities = list(object({<br/>      name = string<br/>    }))<br/>    analytical_storage = list(object({<br/>      schema_type = string<br/>    }))<br/>    capacity = list(object({<br/>      total_throughput_limit = number<br/>    }))<br/>    backup = list(object({<br/>      name                = string<br/>      type                = string<br/>      tier                = optional(string)<br/>      interval_in_minutes = optional(number)<br/>      retention_in_hours  = optional(number)<br/>      storage_redundancy  = optional(string)<br/>    }))<br/>    cors_rule = list(object({<br/>      name               = string<br/>      allowed_headers    = list(string)<br/>      allowed_methods    = list(string)<br/>      allowed_origins    = list(string)<br/>      exposed_headers    = list(string)<br/>      max_age_in_seconds = optional(number)<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_cosmosdb_postgres"></a> [cosmosdb\_postgres](#input\_cosmosdb\_postgres) | Configuration for Cosmos DB PostgreSQL clusters.<br/><br/>- **name**: The name of the PostgreSQL cluster. This is a unique identifier for the cluster within the resource group.<br/>- **sql\_version**: The major PostgreSQL version on the Azure Cosmos DB for PostgreSQL cluster. Possible values are 11, 12, 13, 14, 15 and 16.<br/>- **node\_count**: (Required) The worker node count of the Azure Cosmos DB for PostgreSQL Cluster. Possible value is between 0 and 20 except 1.<br/>- **node\_vcores**: (Optional) The vCores count on each worker node. Possible values are 1, 2, 4, 8, 16, 32, 64, 96 and 104.<br/>- **citus\_version**: (Optional) The citus extension version on the Azure Cosmos DB for PostgreSQL Cluster. Possible values are 8.3, 9.0, 9.1, 9.2, 9.3, 9.4, 9.5, 10.0, 10.1, 10.2, 11.0, 11.1, 11.2, 11.3 and 12.1.<br/>- **coordinator\_server\_edition**: (Optional) The edition of the coordinator server. Possible values are BurstableGeneralPurpose, BurstableMemoryOptimized, GeneralPurpose and MemoryOptimized. Defaults to GeneralPurpose.<br/>- **coordinator\_storage\_quota\_in\_mb**: (Optional) The storage quota for the coordinator node, specified in megabytes.<br/>- **coordinator\_vcore\_count**: (Optional) The coordinator vCore count for the Azure Cosmos DB for PostgreSQL Cluster. Possible values are 1, 2, 4, 8, 16, 32, 64 and 96.<br/>- **node\_server\_edition**: (Optional) The edition of the node server. Possible values are BurstableGeneralPurpose, BurstableMemoryOptimized, GeneralPurpose and MemoryOptimized. Defaults to MemoryOptimized<br/>- **node\_storage\_quota\_in\_mb**: (Optional) The storage quota in MB on each worker node. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608 and 16777216.<br/>- **ha\_enabled**: (Optional) Is high availability enabled for the Azure Cosmos DB for PostgreSQL cluster? Defaults to true.<br/>- **maintenance\_window**: (Optional) Specifies the maintenance window for the cluster. Includes:<br/>  - **day\_of\_week**: Day of the week to perform maintenance (0 for Sunday, 6 for Saturday).<br/>  - **start\_hour**: Hour at which maintenance should begin (in 24-hour format).<br/>  - **start\_minute**: Minute of the hour to begin maintenance. | <pre>list(object({<br/>    name                            = string<br/>    sql_version                     = optional(string)<br/>    node_count                      = number<br/>    node_vcores                     = optional(number)<br/>    citus_version                   = optional(string)<br/>    coordinator_server_edition      = optional(string, "GeneralPurpose")<br/>    coordinator_storage_quota_in_mb = optional(number)<br/>    coordinator_vcore_count         = optional(number)<br/>    node_server_edition             = optional(string, "MemoryOptimized")<br/>    node_storage_quota_in_mb        = optional(number)<br/>    ha_enabled                      = optional(bool, true)<br/>    maintenance_window = optional(object({<br/>      day_of_week  = optional(number)<br/>      start_hour   = optional(number)<br/>      start_minute = optional(number)<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_default_identity_type"></a> [default\_identity\_type](#input\_default\_identity\_type) | The default identity for accessing Key Vault. Possible values are FirstPartyIdentity, SystemAssignedIdentity or UserAssignedIdentity. Defaults to UserAssignedIdentity | `string` | `"UserAssignedIdentity"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). | `string` | `"UserAssigned"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault where the keys are stored | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The default location where the Static App will be created | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where your resources should reside | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |
| <a name="input_umids_names"></a> [umids\_names](#input\_umids\_names) | (Optional) The list of User Assigned Managed Identity names to assign to the App Configuration. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

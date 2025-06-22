| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_mssql_server?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2554&branchName=main) | **v3.0.3** | 24/02/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Resource Configuration](#microsoft-sql-server-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# [Microsoft SQL Server Configuration](https://learn.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver16/?wt.mc_id=DT-MVP-5004771)

----------------------------

This module is used to deploy a private endpointed MSSQL Server in Azure with vulnerability assessments, auditing and threat detection enabled by default.  
Only AzureAD/EntraID users are allowed to access the server as per Axso Security and Azure Policy.  
The MsSql server is deployed in a subnet with a private endpoint to the Azure SQL service, as per Axso Security and Azure Policy firewall rules and service endpoints are not allowed.  

 Ability to create and configure an elastic pool on the MsSql Server (Optional)  
 Ability to create and configure MsSql databases on the MsSql Server (Optional)  

## Service Description

----------------------------

**Microsoft SQL Server:**
Microsoft SQL Server is a relational database management system (RDBMS) that provides comprehensive database services for storing, retrieving, and managing data. It offers advanced features like high availability, in-memory processing, data encryption, and integration with various Microsoft services. SQL Server supports various data types, indexing, and querying capabilities, making it suitable for enterprise-level applications. It can be deployed on-premises, in the cloud (Azure SQL), or in a hybrid environment, providing flexibility and scalability to meet different business needs.

**MSSQL Elastic Pool:**
MSSQL Elastic Pool is a resource management solution within Azure SQL Database that allows you to manage and scale multiple databases with variable and unpredictable usage patterns efficiently. It provides a shared set of resources (like CPU, memory, and storage) that multiple databases can draw from, allowing you to optimize performance and cost. Instead of provisioning resources for each database individually, you allocate resources to the pool, and the databases share them as needed. Elastic pools are ideal for scenarios where database usage varies, as they help ensure that resources are used efficiently and that performance is maintained across all databases.

**MS Database:**
MS Database (Microsoft Database) generally refers to any database service offered by Microsoft, most commonly associated with Azure SQL Database or SQL Server. These databases are fully managed, relational database services that provide a scalable, secure, and high-performance data storage solution. They support features like automated backups, point-in-time restore, and dynamic scaling, allowing you to manage your data with minimal administrative overhead. MS Databases are integrated with the broader Azure ecosystem, enabling seamless connectivity to other Azure services, analytics, and AI tools.

## Deployed Resources

----------------------------

- azurerm_mssql_server
- azurerm_role_assignment
- azurerm_storage_container
- azurerm_mssql_server_extended_auditing_policy
- azurerm_mssql_server_security_alert_policy
- azurerm_mssql_server_vulnerability_assessment
- azurerm_private_endpoint
- azurerm_mssql_elasticpool (Optional)
- azurerm_mssql_database (Optional)

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Azure **Resource Group**  
- Azure **Virtual Network**  
- Azure **Subnet** for the MsSql server Private Endpoint  
- Azure **Storage Account** for SQL Server vulnerability assessment and threat detection logs + auditing  

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-sqlserver"`  
**NonProd:** `axso-np-appl-etools-dev-sqlserver`  
**Prod:** `axso-p-appl-etools-prod-sqlserver`

## Terraform Files

----------------------------

## module.tf

```hcl
module "axso_mssql_server" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_mssql_server?ref=v3.0.3"
  # naming_convention 
  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment

  # Server params
  location                                              = var.location
  server_version                                        = var.server_version
  threat_detection_policy                               = var.threat_detection_policy
  azurerm_mssql_server_vulnerability_assessment_enabled = var.azurerm_mssql_server_vulnerability_assessment_enabled

  # EntraID Administrator  
  resource_group_name         = var.resource_group_name
  login_username              = var.login_username
  mssql_administrator_group   = var.mssql_administrator_group
  key_vault_name              = var.key_vault_name
  azuread_authentication_only = var.azuread_authentication_only

  # Private endpoint
  network_resource_group_name = var.network_resource_group_name
  network_name                = var.virtual_network_name
  mssql_subnet_name           = var.mssql_subnet_name

  # vulnerability scan results and audit logs
  storage_account_name = var.storage_account_name
  email_accounts       = var.email_accounts

  # Create Elastic Pool (optional) with default values
  create_elastic_pool = var.create_elastic_pool
  elastic_pool_config = var.elastic_pool_config

  # MSSQL Databases
  mssql_databases = var.mssql_databases
}
```

## module.tf.tfvars

```hcl
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
```

## variables.tf

```hcl
# Common Vars
variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the MSSQL resources will be created."
  nullable    = false
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}


variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "project"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' or 'np'"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault to store the MSSQL server password."

}

###### Azure SQL Server ######
variable "server_version" {
  type        = string
  default     = "12.0"
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created."
}

variable "mssql_administrator_group" {
  type        = string
  description = "The Azure AD group that will be the administrator for the MSSQL server."
}

variable "azuread_authentication_only" {
  type        = bool
  description = "Specifies whether Azure Active Directory only authentication is enabled. Changing this forces a new resource to be created."
  default     = false

}

variable "login_username" {
  description = "The Azure login username details for the server."
  type        = string
}

variable "threat_detection_policy" {
  description = "The threat detection policy for the MSSQL server."
  type        = string
  default     = "Disabled"
}

variable "azurerm_mssql_server_vulnerability_assessment_enabled" {
  description = "Specifies whether the vulnerability assessment is enabled on the MSSQL server."
  type        = bool
  default     = false

}

# Private endpoint (used in data block to get subnet ID)
variable "virtual_network_name" {
  type        = string
  description = "Virtual network name for the enviornment to enable MS SQL private endpoint."
}

variable "mssql_subnet_name" {
  type        = string
  description = "The name for data subnet, used in data source to get subnet ID, to enable the MS SQL private endpoint."
}

variable "network_resource_group_name" {
  type        = string
  description = "The existing core network resource group name, to get details of the VNET to enable MS SQL private endpoint."
}

# vulnerability scan results and audit logs (used in data block to get storage account details)
variable "storage_account_name" {
  type        = string
  description = "Storage account name to keep vulnerability assessment scan results and audit logs"
}

variable "email_accounts" {
  type        = list(string)
  description = "Email accounts to send vulnerability assessment scan results, security alerts and audit logs"
}

# MS SQL Elastic Pool
variable "create_elastic_pool" {
  type        = bool
  description = "(Optional)Create an elastic pool for the MSSQL server."
  default     = false
}

variable "elastic_pool_config" {
  type = object({
    name                = string
    max_size_gb         = number
    sku_name            = string
    sku_tier            = string
    sku_family          = string
    sku_capacity        = number
    per_db_min_capacity = number
    per_db_max_capacity = number
    zone_redundant      = bool
  })
  default = {
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
  description = <<-DESCRIPTION
      (Optional)
      type = object({  
        **name**                = The name of the elastic pool. This needs to be globally unique. Changing this forces a new resource to be created.  
        **max_size_gb**         = The max data size of the elastic pool in gigabytes.  
        **sku_name**            = Specifies the SKU Name for this Elasticpool. The name of the SKU, will be either vCore based or DTU based. Possible DTU based values are BasicPool, StandardPool, PremiumPool while possible vCore based values are GP_Gen4, GP_Gen5, GP_Fsv2, GP_DC, BC_Gen4, BC_Gen5, BC_DC, HS_PRMS, HS_MOPRMS, or HS_Gen5.
        **sku_tier**            = The tier of the particular SKU. Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, Premium, or HyperScale. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.  
        **zone_redundant**      = (Optional) Whether or not this elastic pool is zone redundant. tier needs to be Premium for DTU based or BusinessCritical for vCore based sku.
        **sku_family**          = The family of hardware Gen4, Gen5, Fsv2 or DC.  
        **sku_capacity**        = The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.  
        **per_db_min_capacity** = The minimum capacity all databases are guaranteed.  
        **per_db_max_capacity** = The maximum capacity any one database can consume.  
      })  
  DESCRIPTION
}

# MS SQL Databases
variable "mssql_databases" {
  type = list(object({
    create_db                   = bool
    db_name                     = string
    attach_to_elasticpool       = bool
    collation                   = string
    create_mode                 = string
    max_size_gb                 = number
    min_capacity                = number
    sku_name                    = string
    storage_account_type        = string
    zone_redundant              = bool
    auto_pause_delay_in_minutes = number
    short_term_retention_days   = number
    ltr_weekly_retention        = string

  }))
  default = [
    {
      create_db                   = true
      db_name                     = "test-db"
      attach_to_elasticpool       = true
      collation                   = "SQL_Latin1_General_CP1_CI_AS"
      create_mode                 = "Default"
      max_size_gb                 = null
      min_capacity                = null
      sku_name                    = "P2"
      storage_account_type        = "Zone"
      zone_redundant              = true
      auto_pause_delay_in_minutes = null
      short_term_retention_days   = 7
      ltr_weekly_retention        = "P7D"
    }
  ]
  description = <<-DESCRIPTION
      (Optional)
      type = list(object({ 
        **create_db**                   = Create this database on the mssql server. (True/False)  
        **db_name**                     = The name of the database. Changing this forces a new resource to be created.  
        **attach_to_elasticpool**       = Attach the database to an existing elastic pool on the mssql server or stand-alone.    
        **collation**                   = Specifies the collation of the database. Changing this forces a new resource to be created.  
        **create_mode**                 = The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. Changing this forces a new resource to be created. Defaults to Default.  
        **max_size_gb**                 = The max size of the database in gigabytes.  
        **min_capacity**                = The min capacity of the database.  
        **sku_name**                    = Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will create a new resource.  
        **zone_redundant**              = Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases.
        **storage_account_type**        = Specifies the storage account type used to store backups for this database. Possible values are Geo, GeoZone, Local and Zone. Defaults to Zone.
        **short_term_retention_days**   = The number of days to retain short term retention backups.  
        **ltr_weekly_retention**        = The weekly retention policy for long term retention backups.  
      }))  
  DESCRIPTION
}
```

## main.tf

```hcl
terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.8.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 3.0.2"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  resource_provider_registrations = "none"
  storage_use_azuread             = true
}

provider "azuread" {
}
```

# Input Description

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
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  resource_provider_registrations = "none"
  storage_use_azuread             = true
}

provider "azuread" {
}
```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.1 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.mysql_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_mssql_database.databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_elasticpool.msssql_elastic_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_elasticpool) | resource |
| [azurerm_mssql_server.mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.auditing_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_server_security_alert_policy.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_security_alert_policy) | resource |
| [azurerm_mssql_server_vulnerability_assessment.vunerability_assessment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_vulnerability_assessment) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.sa_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_container.vulnerability_scan_results](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [random_password.msql_administrator_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_group.mssql_administrator_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.mssql_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azuread_authentication_only"></a> [azuread\_authentication\_only](#input\_azuread\_authentication\_only) | Specifies whether Azure Active Directory only authentication is enabled. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_azurerm_mssql_server_vulnerability_assessment_enabled"></a> [azurerm\_mssql\_server\_vulnerability\_assessment\_enabled](#input\_azurerm\_mssql\_server\_vulnerability\_assessment\_enabled) | Specifies whether the vulnerability assessment is enabled on the MSSQL server. | `bool` | `false` | no |
| <a name="input_create_elastic_pool"></a> [create\_elastic\_pool](#input\_create\_elastic\_pool) | (Optional)Create an elastic pool for the MSSQL server. | `bool` | `false` | no |
| <a name="input_elastic_pool_config"></a> [elastic\_pool\_config](#input\_elastic\_pool\_config) | (Optional)<br/>type = object({<br/>  **name**                = The name of the elastic pool. This needs to be globally unique. Changing this forces a new resource to be created.<br/>  **max\_size\_gb**         = The max data size of the elastic pool in gigabytes.<br/>  **sku\_name**            = Specifies the SKU Name for this Elasticpool. The name of the SKU, will be either vCore based or DTU based. Possible DTU based values are BasicPool, StandardPool, PremiumPool while possible vCore based values are GP\_Gen4, GP\_Gen5, GP\_Fsv2, GP\_DC, BC\_Gen4, BC\_Gen5, BC\_DC, HS\_PRMS, HS\_MOPRMS, or HS\_Gen5.<br/>  **sku\_tier**            = The tier of the particular SKU. Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, Premium, or HyperScale. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.<br/>  **zone\_redundant**      = (Optional) Whether or not this elastic pool is zone redundant. tier needs to be Premium for DTU based or BusinessCritical for vCore based sku.<br/>  **sku\_family**          = The family of hardware Gen4, Gen5, Fsv2 or DC.<br/>  **sku\_capacity**        = The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.<br/>  **per\_db\_min\_capacity** = The minimum capacity all databases are guaranteed.<br/>  **per\_db\_max\_capacity** = The maximum capacity any one database can consume.<br/>}) | <pre>object({<br/>    name                = string<br/>    max_size_gb         = number<br/>    sku_name            = string<br/>    sku_tier            = string<br/>    sku_family          = string<br/>    sku_capacity        = number<br/>    per_db_min_capacity = number<br/>    per_db_max_capacity = number<br/>    zone_redundant      = bool<br/>  })</pre> | <pre>{<br/>  "max_size_gb": 50,<br/>  "name": "test-elasticpool",<br/>  "per_db_max_capacity": 25,<br/>  "per_db_min_capacity": 0,<br/>  "sku_capacity": 125,<br/>  "sku_family": null,<br/>  "sku_name": "PremiumPool",<br/>  "sku_tier": "Premium",<br/>  "zone_redundant": true<br/>}</pre> | no |
| <a name="input_email_accounts"></a> [email\_accounts](#input\_email\_accounts) | Email accounts to send vulnerability assessment scan results, security alerts and audit logs | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault to store the MSSQL server password. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | `"westeurope"` | no |
| <a name="input_login_username"></a> [login\_username](#input\_login\_username) | The Azure login username details for the server. | `string` | n/a | yes |
| <a name="input_mssql_administrator_group"></a> [mssql\_administrator\_group](#input\_mssql\_administrator\_group) | The Azure AD group that will be the administrator for the MSSQL server. | `string` | n/a | yes |
| <a name="input_mssql_databases"></a> [mssql\_databases](#input\_mssql\_databases) | (Optional)<br/>type = list(object({ <br/>  **create\_db**                   = Create this database on the mssql server. (True/False)<br/>  **db\_name**                     = The name of the database. Changing this forces a new resource to be created.<br/>  **attach\_to\_elasticpool**       = Attach the database to an existing elastic pool on the mssql server or stand-alone.<br/>  **collation**                   = Specifies the collation of the database. Changing this forces a new resource to be created.<br/>  **create\_mode**                 = The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. Changing this forces a new resource to be created. Defaults to Default.<br/>  **max\_size\_gb**                 = The max size of the database in gigabytes.<br/>  **min\_capacity**                = The min capacity of the database.<br/>  **sku\_name**                    = Specifies the name of the SKU used by the database. For example, GP\_S\_Gen5\_2,HS\_Gen4\_1,BC\_Gen5\_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will create a new resource.<br/>  **zone\_redundant**              = Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases.<br/>  **storage\_account\_type**        = Specifies the storage account type used to store backups for this database. Possible values are Geo, GeoZone, Local and Zone. Defaults to Zone.<br/>  **short\_term\_retention\_days**   = The number of days to retain short term retention backups.<br/>  **ltr\_weekly\_retention**        = The weekly retention policy for long term retention backups.<br/>})) | <pre>list(object({<br/>    create_db                   = bool<br/>    db_name                     = string<br/>    attach_to_elasticpool       = bool<br/>    collation                   = string<br/>    create_mode                 = string<br/>    max_size_gb                 = number<br/>    min_capacity                = number<br/>    sku_name                    = string<br/>    storage_account_type        = string<br/>    zone_redundant              = bool<br/>    auto_pause_delay_in_minutes = number<br/>    short_term_retention_days   = number<br/>    ltr_weekly_retention        = string<br/><br/>  }))</pre> | <pre>[<br/>  {<br/>    "attach_to_elasticpool": true,<br/>    "auto_pause_delay_in_minutes": null,<br/>    "collation": "SQL_Latin1_General_CP1_CI_AS",<br/>    "create_db": true,<br/>    "create_mode": "Default",<br/>    "db_name": "test-db",<br/>    "ltr_weekly_retention": "P7D",<br/>    "max_size_gb": null,<br/>    "min_capacity": null,<br/>    "short_term_retention_days": 7,<br/>    "sku_name": "P2",<br/>    "storage_account_type": "Zone",<br/>    "zone_redundant": true<br/>  }<br/>]</pre> | no |
| <a name="input_mssql_subnet_name"></a> [mssql\_subnet\_name](#input\_mssql\_subnet\_name) | The name for data subnet, used in data source to get subnet ID, to enable the MS SQL private endpoint. | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Virtual network name for the enviornment to enable MS SQL private endpoint. | `string` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The existing core network resource group name, to get details of the VNET to enable MS SQL private endpoint. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"project"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the MSSQL resources will be created. | `string` | n/a | yes |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created. | `string` | `"12.0"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage account name to keep vulnerability assessment scan results and audit logs | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"np"` | no |
| <a name="input_threat_detection_policy"></a> [threat\_detection\_policy](#input\_threat\_detection\_policy) | The threat detection policy for the MSSQL server. | `string` | `"Disabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fully_qualified_domain_name"></a> [fully\_qualified\_domain\_name](#output\_fully\_qualified\_domain\_name) | value of the mssql server fully qualified domain name |
| <a name="output_mssql_server_id"></a> [mssql\_server\_id](#output\_mssql\_server\_id) | value of the mssql server id |
| <a name="output_mssql_server_name"></a> [mssql\_server\_name](#output\_mssql\_server\_name) | value of the mssql server name |
| <a name="output_msssql_elastic_pool_id"></a> [msssql\_elastic\_pool\_id](#output\_msssql\_elastic\_pool\_id) | value of the mssql elastic pool id |
| <a name="output_msssql_elastic_pool_name"></a> [msssql\_elastic\_pool\_name](#output\_msssql\_elastic\_pool\_name) | value of the mssql elastic pool name |
<!-- END_TF_DOCS -->

| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_mssql_server?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2554&branchName=main) | **v3.0.3** | 24/02/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Microsoft SQL Server Configuration](#microsoft-sql-server-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# [Microsoft SQL Server Configuration]

[Learn more about Microsoft SQL server in the Microsoft Documentation](https://learn.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver16/?wt.mc_id=DT-MVP-5004771)

----------------------------

This module is used to deploy a private endpointed MSSQL Server in Azure with vulnerability assessments, auditing and threat detection enabled by default.  
Only AzureAD/EntraID users are allowed to access the server as per Axso Security and Azure Policy.  
The MsSql server is deployed in a subnet with a private endpoint to the Azure SQL service, as per Axso Security and Azure Policy firewall rules and service endpoints are not allowed.  

 Ability to create and configure an elastic pool on the MsSql Server (Optional)  
 Ability to create and configure MsSql databases on the MsSql Server (Optional)  

## Service Description

----------------------------

**Microsoft SQL Server:**
Microsoft SQL Server is a relational database management system (RDBMS) that provides comprehensive database services for storing, retrieving, and managing data. It offers advanced features like high availability, in-memory processing, data encryption, and integration with various Microsoft services. SQL Server supports various data types, indexing, and querying capabilities, making it suitable for enterprise-level applications. It can be deployed on-premises, in the cloud (Azure SQL), or in a hybrid environment, providing flexibility and scalability to meet different business needs.

**MSSQL Elastic Pool:**
MSSQL Elastic Pool is a resource management solution within Azure SQL Database that allows you to manage and scale multiple databases with variable and unpredictable usage patterns efficiently. It provides a shared set of resources (like CPU, memory, and storage) that multiple databases can draw from, allowing you to optimize performance and cost. Instead of provisioning resources for each database individually, you allocate resources to the pool, and the databases share them as needed. Elastic pools are ideal for scenarios where database usage varies, as they help ensure that resources are used efficiently and that performance is maintained across all databases.

**MS Database:**
MS Database (Microsoft Database) generally refers to any database service offered by Microsoft, most commonly associated with Azure SQL Database or SQL Server. These databases are fully managed, relational database services that provide a scalable, secure, and high-performance data storage solution. They support features like automated backups, point-in-time restore, and dynamic scaling, allowing you to manage your data with minimal administrative overhead. MS Databases are integrated with the broader Azure ecosystem, enabling seamless connectivity to other Azure services, analytics, and AI tools.

## Deployed Resources

----------------------------

- azurerm_mssql_server
- azurerm_role_assignment
- azurerm_storage_container
- azurerm_mssql_server_extended_auditing_policy
- azurerm_mssql_server_security_alert_policy
- azurerm_mssql_server_vulnerability_assessment
- azurerm_private_endpoint
- azurerm_mssql_elasticpool (Optional)
- azurerm_mssql_database (Optional)

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Azure **Resource Group**  
- Azure **Virtual Network**  
- Azure **Subnet** for the MsSql server Private Endpoint  
- Azure **Storage Account** for SQL Server vulnerability assessment and threat detection logs + auditing  

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-sqlserver"`  
**NonProd:** `axso-np-appl-etools-dev-sqlserver`  
**Prod:** `axso-p-appl-etools-prod-sqlserver`

## Terraform Files

----------------------------

## module.tf

```hcl
module "axso_mssql_server" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_mssql_server?ref=v3.0.3"
  # naming_convention 
  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment

  # Server params
  location                                              = var.location
  server_version                                        = var.server_version
  threat_detection_policy                               = var.threat_detection_policy
  azurerm_mssql_server_vulnerability_assessment_enabled = var.azurerm_mssql_server_vulnerability_assessment_enabled

  # EntraID Administrator  
  resource_group_name         = var.resource_group_name
  login_username              = var.login_username
  mssql_administrator_group    = var.mssql_administrator_group
  key_vault_name              = var.key_vault_name
  azuread_authentication_only = var.azuread_authentication_only


  # Private endpoint
  network_resource_group_name = var.network_resource_group_name
  network_name                = var.virtual_network_name
  mssql_subnet_name           = var.mssql_subnet_name

  # vulnerability scan results and audit logs
  storage_account_name = var.storage_account_name
  email_accounts       = var.email_accounts

  # Create Elastic Pool (optional) with default values
  create_elastic_pool = var.create_elastic_pool
  elastic_pool_config = var.elastic_pool_config

  # MSSQL Databases
  mssql_databases = var.mssql_databases
}
```

## module.tf.tfvars

```hcl
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
mssql_administrator_group                              = "testaaa"
azuread_authentication_only                           = true
threat_detection_policy                               = "Disabled"
azurerm_mssql_server_vulnerability_assessment_enabled = false

create_elastic_pool = true
elastic_pool_config = {
  name                = "test-elasticpool"
  max_size_gb         = 50
  sku_name            = "BasicPool"
  sku_tier            = "Standard"
  sku_family          = null
  sku_capacity        = 50
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
    sku_name                    = "S0"
    storage_account_type        = "Zone"
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
    storage_account_type        = "Local"
    auto_pause_delay_in_minutes = null
    short_term_retention_days   = 7
    ltr_weekly_retention        = "P7D"
  }
]
```

## variables.tf

```hcl
# Common Vars
variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the MSSQL resources will be created."
  nullable    = false
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}


variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "project"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' or 'np'"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the key vault to store the MSSQL server password."

}

###### Azure SQL Server ######
variable "server_version" {
  type        = string
  default     = "12.0"
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created."
}

variable "mssql_administrator_group" {
  type        = string
  description = "The Azure AD group that will be the administrator for the MSSQL server."
}

variable "azuread_authentication_only" {
  type        = bool
  description = "Specifies whether Azure Active Directory only authentication is enabled. Changing this forces a new resource to be created."
  default     = false

}

variable "login_username" {
  description = "The Azure login username details for the server."
  type        = string
}

variable "threat_detection_policy" {
  description = "The threat detection policy for the MSSQL server."
  type        = string
  default     = "Disabled"
}

variable "azurerm_mssql_server_vulnerability_assessment_enabled" {
  description = "Specifies whether the vulnerability assessment is enabled on the MSSQL server."
  type        = bool
  default     = false

}

# Private endpoint (used in data block to get subnet ID)
variable "virtual_network_name" {
  type        = string
  description = "Virtual network name for the enviornment to enable MS SQL private endpoint."
}

variable "mssql_subnet_name" {
  type        = string
  description = "The name for data subnet, used in data source to get subnet ID, to enable the MS SQL private endpoint."
}

variable "network_resource_group_name" {
  type        = string
  description = "The existing core network resource group name, to get details of the VNET to enable MS SQL private endpoint."
}

# vulnerability scan results and audit logs (used in data block to get storage account details)
variable "storage_account_name" {
  type        = string
  description = "Storage account name to keep vulnerability assessment scan results and audit logs"
}

variable "email_accounts" {
  type        = list(string)
  description = "Email accounts to send vulnerability assessment scan results, security alerts and audit logs"
}

# MS SQL Elastic Pool
variable "create_elastic_pool" {
  type        = bool
  description = "(Optional)Create an elastic pool for the MSSQL server."
  default     = false
}

variable "elastic_pool_config" {
  type = object({
    name                = string
    max_size_gb         = number
    sku_name            = string
    sku_tier            = string
    sku_family          = string
    sku_capacity        = number
    per_db_min_capacity = number
    per_db_max_capacity = number
  })
  default = {
    name                = "test-elasticpool"
    max_size_gb         = 50
    sku_name            = "BasicPool"
    sku_tier            = "Standard"
    sku_family          = null
    sku_capacity        = 50
    per_db_min_capacity = 0
    per_db_max_capacity = 25
  }
  description = <<-DESCRIPTION
      (Optional)
      type = object({  
        **name**                = The name of the elastic pool. This needs to be globally unique. Changing this forces a new resource to be created.  
        **max_size_gb**         = The max data size of the elastic pool in gigabytes.  
        **sku_name**            = Specifies the SKU Name for this Elasticpool. The name of the SKU, will be either vCore based tier + family pattern (e.g. GP_Gen4, BC_Gen5) or the DTU based BasicPool, StandardPool, or PremiumPool pattern. Possible values are BasicPool, StandardPool, PremiumPool, GP_Gen4, GP_Gen5, GP_Fsv2, GP_DC, BC_Gen4, BC_Gen5, BC_DC, or HS_Gen5.  
        **sku_tier**            = The tier of the particular SKU. Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, Premium, or HyperScale. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.  
        **sku_family**          = The family of hardware Gen4, Gen5, Fsv2 or DC.  
        **sku_capacity**        = The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.  
        **per_db_min_capacity** = The minimum capacity all databases are guaranteed.  
        **per_db_max_capacity** = The maximum capacity any one database can consume.  
      })  
  DESCRIPTION
}

# MS SQL Databases
variable "mssql_databases" {
  type = list(object({
    create_db                   = bool
    db_name                     = string
    attach_to_elasticpool       = bool
    collation                   = string
    create_mode                 = string
    max_size_gb                 = number
    min_capacity                = number
    sku_name                    = string
    storage_account_type        = string
    auto_pause_delay_in_minutes = number
    short_term_retention_days   = number
    ltr_weekly_retention        = string

  }))
  default = [
    {
      create_db                   = true
      db_name                     = "test-db"
      attach_to_elasticpool       = true
      collation                   = "SQL_Latin1_General_CP1_CI_AS"
      create_mode                 = "Default"
      max_size_gb                 = null
      min_capacity                = null
      sku_name                    = "ElasticPool"
      storage_account_type        = "LRS"
      auto_pause_delay_in_minutes = null
      short_term_retention_days   = 7
      ltr_weekly_retention        = "P7D"
    }
  ]
  description = <<-DESCRIPTION
      (Optional)
      type = list(object({ 
        **create_db**                   = Create this database on the mssql server. (True/False)  
        **db_name**                     = The name of the database. Changing this forces a new resource to be created.  
        **attach_to_elasticpool**       = Attach the database to an existing elastic pool on the mssql server or stand-alone.    
        **collation**                   = Specifies the collation of the database. Changing this forces a new resource to be created.  
        **create_mode**                 = The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. Changing this forces a new resource to be created. Defaults to Default.  
        **max_size_gb**                 = The max size of the database in gigabytes.  
        **min_capacity**                = The min capacity of the database.  
        **sku_name**                    = Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will create a new resource.  
        **zone_redundant**              = This value is set automatically based on the value of the 'sku_name' parameter in the parent resource, "Premium", "BusinessCritical" will be set to true, anything else will be false.                    
        **auto_pause_delay_in_minutes** = Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for Serverless databases.
        **short_term_retention_days**   = The number of days to retain short term retention backups.  
        **ltr_weekly_retention**        = The weekly retention policy for long term retention backups.  
      }))  
  DESCRIPTION
}

```

<!-- BEGIN_TF_DOCS -->


## main.tf

```hcl
terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  resource_provider_registrations = "none"
  storage_use_azuread             = true
}

provider "azuread" {
}
```

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.53 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.mysql_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_mssql_database.databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_elasticpool.msssql_elastic_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_elasticpool) | resource |
| [azurerm_mssql_server.mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.auditing_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_server_security_alert_policy.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_security_alert_policy) | resource |
| [azurerm_mssql_server_vulnerability_assessment.vunerability_assessment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_vulnerability_assessment) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.sa_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_container.vulnerability_scan_results](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [random_password.msql_administrator_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_group.mssql_administrator_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.mssql_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azuread_authentication_only"></a> [azuread\_authentication\_only](#input\_azuread\_authentication\_only) | Specifies whether Azure Active Directory only authentication is enabled. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_azurerm_mssql_server_vulnerability_assessment_enabled"></a> [azurerm\_mssql\_server\_vulnerability\_assessment\_enabled](#input\_azurerm\_mssql\_server\_vulnerability\_assessment\_enabled) | Specifies whether the vulnerability assessment is enabled on the MSSQL server. | `bool` | `false` | no |
| <a name="input_create_elastic_pool"></a> [create\_elastic\_pool](#input\_create\_elastic\_pool) | (Optional)Create an elastic pool for the MSSQL server. | `bool` | `false` | no |
| <a name="input_elastic_pool_config"></a> [elastic\_pool\_config](#input\_elastic\_pool\_config) | (Optional)<br>type = object({<br>  **name**                = The name of the elastic pool. This needs to be globally unique. Changing this forces a new resource to be created.<br>  **max\_size\_gb**         = The max data size of the elastic pool in gigabytes.<br>  **sku\_name**            = Specifies the SKU Name for this Elasticpool. The name of the SKU, will be either vCore based tier + family pattern (e.g. GP\_Gen4, BC\_Gen5) or the DTU based BasicPool, StandardPool, or PremiumPool pattern. Possible values are BasicPool, StandardPool, PremiumPool, GP\_Gen4, GP\_Gen5, GP\_Fsv2, GP\_DC, BC\_Gen4, BC\_Gen5, BC\_DC, or HS\_Gen5.<br>  **sku\_tier**            = The tier of the particular SKU. Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, Premium, or HyperScale. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.<br>  **sku\_family**          = The family of hardware Gen4, Gen5, Fsv2 or DC.<br>  **sku\_capacity**        = The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based.<br>  **per\_db\_min\_capacity** = The minimum capacity all databases are guaranteed.<br>  **per\_db\_max\_capacity** = The maximum capacity any one database can consume.<br>}) | <pre>object({<br>    name                = string<br>    max_size_gb         = number<br>    sku_name            = string<br>    sku_tier            = string<br>    sku_family          = string<br>    sku_capacity        = number<br>    per_db_min_capacity = number<br>    per_db_max_capacity = number<br>  })</pre> | <pre>{<br>  "max_size_gb": 4.8828125,<br>  "name": "test-elasticpool",<br>  "per_db_max_capacity": 5,<br>  "per_db_min_capacity": 0,<br>  "sku_capacity": 50,<br>  "sku_family": null,<br>  "sku_name": "BasicPool",<br>  "sku_tier": "Standard"<br>}</pre> | no |
| <a name="input_email_accounts"></a> [email\_accounts](#input\_email\_accounts) | Email accounts to send vulnerability assessment scan results, security alerts and audit logs | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault to store the MSSQL server password. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created. The full list of Azure regions can be found at <https://azure.microsoft.com/regions> | `string` | `"westeurope"` | no |
| <a name="input_login_username"></a> [login\_username](#input\_login\_username) | The Azure login username details for the server. | `string` | n/a | yes |
| <a name="input_mssql_administrator_group"></a> [msql\_administrator\_group](#input\_msql\_administrator\_group) | The Azure AD group that will be the administrator for the MSSQL server. | `string` | n/a | yes |
| <a name="input_mssql_databases"></a> [mssql\_databases](#input\_mssql\_databases) | (Optional)<br>type = list(object({ <br>  **create\_db**                   = Create this database on the mssql server. (True/False)<br>  **db\_name**                     = The name of the database. Changing this forces a new resource to be created.<br>  **attach\_to\_elasticpool**       = Attach the database to an existing elastic pool on the mssql server or stand-alone.<br>  **collation**                   = Specifies the collation of the database. Changing this forces a new resource to be created.<br>  **create\_mode**                 = The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. Changing this forces a new resource to be created. Defaults to Default.<br>  **max\_size\_gb**                 = The max size of the database in gigabytes.<br>  **min\_capacity**                = The min capacity of the database.<br>  **sku\_name**                    = Specifies the name of the SKU used by the database. For example, GP\_S\_Gen5\_2,HS\_Gen4\_1,BC\_Gen5\_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will create a new resource.<br>  **zone\_redundant**              = Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones.<br>  **auto\_pause\_delay\_in\_minutes** = Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for Serverless databases.<br>  **short\_term\_retention\_days**   = The number of days to retain short term retention backups.<br>  **ltr\_weekly\_retention**        = The weekly retention policy for long term retention backups.<br>})) | <pre>list(object({<br>    create_db                   = bool<br>    db_name                     = string<br>    attach_to_elasticpool       = bool<br>    collation                   = string<br>    create_mode                 = string<br>    max_size_gb                 = number<br>    min_capacity                = number<br>    sku_name                    = string<br>    zone_redundant              = bool<br>    storage_account_type        = string<br>    auto_pause_delay_in_minutes = number<br>    short_term_retention_days   = number<br>    ltr_weekly_retention        = string<br><br>  }))</pre> | <pre>[<br>  {<br>    "attach_to_elasticpool": true,<br>    "auto_pause_delay_in_minutes": null,<br>    "collation": "SQL_Latin1_General_CP1_CI_AS",<br>    "create_db": true,<br>    "create_mode": "Default",<br>    "db_name": "test-db",<br>    "ltr_weekly_retention": "P7D",<br>    "max_size_gb": null,<br>    "min_capacity": null,<br>    "short_term_retention_days": 7,<br>    "sku_name": "ElasticPool",<br>    "storage_account_type": "LRS",<br>    "zone_redundant": false<br>  }<br>]</pre> | no |
| <a name="input_mssql_subnet_name"></a> [mssql\_subnet\_name](#input\_mssql\_subnet\_name) | The name for data subnet, used in data source to get subnet ID, to enable the MS SQL private endpoint. | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Virtual network name for the enviornment to enable MS SQL private endpoint. | `string` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The existing core network resource group name, to get details of the VNET to enable MS SQL private endpoint. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"project"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the MSSQL resources will be created. | `string` | n/a | yes |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created. | `string` | `"12.0"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage account name to keep vulnerability assessment scan results and audit logs | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"np"` | no |
| <a name="input_threat_detection_policy"></a> [threat\_detection\_policy](#input\_threat\_detection\_policy) | The threat detection policy for the MSSQL server. | `string` | `"Disabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fully_qualified_domain_name"></a> [fully\_qualified\_domain\_name](#output\_fully\_qualified\_domain\_name) | value of the mssql server fully qualified domain name |
| <a name="output_mssql_server_id"></a> [mssql\_server\_id](#output\_mssql\_server\_id) | value of the mssql server id |
| <a name="output_mssql_server_name"></a> [mssql\_server\_name](#output\_mssql\_server\_name) | value of the mssql server name |
| <a name="output_msssql_elastic_pool_id"></a> [msssql\_elastic\_pool\_id](#output\_msssql\_elastic\_pool\_id) | value of the mssql elastic pool id |
| <a name="output_msssql_elastic_pool_name"></a> [msssql\_elastic\_pool\_name](#output\_msssql\_elastic\_pool\_name) | value of the mssql elastic pool name |
<!-- END_TF_DOCS -->

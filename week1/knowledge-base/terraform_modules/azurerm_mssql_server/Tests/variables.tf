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
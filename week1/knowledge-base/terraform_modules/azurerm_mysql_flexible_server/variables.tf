#===========================================================================================================================================#
# MySQL Flexible Server                                                                                                                     
#===========================================================================================================================================#

# Generic

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  type        = string
  description = "The default location where the resource will be created"
  default     = "westeurope"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' for prod or 'np' for nonprod"
  default     = "np"
}

variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "prj"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

#===========================================================================================================================================#
# MySQL authentication                                                                                                                  
#===========================================================================================================================================#

variable "administrator_login" {
  description = "MySQL administrator login"
  type        = string
}

variable "administrator_password" {
  description = "MySQL administrator password. If not set, a random password will be generated and stored in the key vault."
  type        = string
  default     = null
  sensitive   = true
}

variable "administrator_password_expiration_date_secret" {
  description = "The expiration day of the mysql password secret"
  type        = string
}

variable "key_vault_name" {
  description = "The name of the key vault to store the MySQL administrator password."
  type        = string
  default     = null
}

variable "user_assigned_identity_name" {
  description = "The name of the user assigned identity to associate with the MySQL Flexible Server. You have to ask the infra team to add you permissions to the identity.https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#grant-permissions-to-user-assigned-managed-identity"
  type        = string
  default     = ""
}

variable "mysql_administrator_group" {
  description = "AD Group to associate with the MySQL Flexible Server."
  type        = string
  default     = null
}


#===========================================================================================================================================#
# MySQL network                                                                                                                 
#===========================================================================================================================================#

variable "delegated_subnet_details" {
  description = "Details of the subnet to create the MySQL Flexible Server.Be sure to delegate the subnet to Microsoft.DBforMySQL/flexibleServers resource provider."
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
  default = null
}

variable "allowed_cidrs" {
  description = "Map of authorized CIDRs"
  type        = map(string)
  default     = {}
}

#===========================================================================================================================================#
# MySQL configuration                                                                                                                  
#===========================================================================================================================================#

variable "sku_name" {
  description = "(Optional) The SKU Name for the MySQL Flexible Server. NOTE: sku_name should start with SKU tier B (Burstable), GP (General Purpose), MO (Memory Optimized) like B_Standard_B1s."
  type        = string
  default     = "GP_Standard_D2ads_v5"
}

variable "mysql_version" {
  description = "MySQL server version. Valid values are `5.7` and `8.0.21`"
  type        = string
  default     = "8.0.21"
}

variable "zone" {
  description = "Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3"
  type        = number
  default     = null
}

variable "create_mode" {
  description = "The creation mode which can be used to restore or replicate existing servers."
  type        = string
  default     = "Default"
}

variable "mysql_options" {
  description = "Map of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters."
  type        = map(string)
  default     = {}
}

#===========================================================================================================================================#
# MySQL backup and restore                                                                                                                  
#===========================================================================================================================================#

variable "geo_redundant_backup_enabled" {
  description = "Turn Geo-redundant server backups on/off. Not available for the Burstable tier."
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Backup retention days for the server, supported values are between `7` and `35` days."
  type        = number
  default     = 10
}

variable "source_server_id" {
  description = "The resource ID of the source MySQL Flexible Server to be restored."
  type        = string
  default     = null
}

#===========================================================================================================================================#
# MySQL high availability                                                                                                                  
#===========================================================================================================================================#

variable "high_availability" {
  description = "Map of high availability configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability. `null` to disable high availability"
  type = object({
    mode                      = string
    standby_availability_zone = optional(number)
  })
  default = {
    mode                      = "ZoneRedundant"
    standby_availability_zone = 2
  }
}

#===========================================================================================================================================#
# MySQL maintenance window                                                                                                                  
#===========================================================================================================================================#

variable "maintenance_window" {
  description = "Map of maintenance window configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-maintenance"
  type        = map(number)
  default     = null
}

#===========================================================================================================================================#
# MySQL storage                                                                                                                  
#===========================================================================================================================================#

variable "storage" {
  description = "Map of the storage configuration"
  type = object({
    auto_grow_enabled  = optional(bool)
    io_scaling_enabled = optional(bool)
    iops               = optional(number)
    size_gb            = optional(number)
  })
  default = null
}

#===========================================================================================================================================#
# MySQL databases                                                                                                                  
#===========================================================================================================================================#

variable "databases" {
  description = "Map of databases with default collation and charset."
  type        = map(map(string))
}

variable "ssl_enforced" {
  description = "Enforce SSL connection on MySQL provider and set require_secure_transport on MySQL Server"
  type        = bool
  default     = true
}

#===========================================================================================================================================#
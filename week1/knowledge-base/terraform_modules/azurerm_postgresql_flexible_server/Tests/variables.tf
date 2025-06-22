# Prerequisites:

# Admin EID group for access to the PostgreSQL server

variable "postgresql_administrator_group" {
  type        = string
  default     = null
  description = "The name of the EID group that will be the PostgreSQL server administrator"
}

variable "keyvault_name" {
  type        = string
  description = "The name of the KeyVault to store the PostgreSQL server administrator login name and password"
}

variable "keyvault_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the KeyVault is located"
}

#----------------------------#
# PostgreSQL flexible server #
#----------------------------#

# General configuration

variable "project_name" {
  type        = string
  default     = "etools"
  description = "The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.."
}

variable "subscription" {
  type        = string
  default     = "p"
  description = "The subscription type e.g. 'p' or 'np'"
}

variable "environment" {
  type        = string
  default     = "prod "
  description = "The environment. e.g. dev, qa, uat, prod"
}

variable "resource_group_name" {
  type        = string
  default     = "axso-np-appl-<project-name>-<environment>-rg"
  description = "(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "west europe"
  description = "(Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created."
}

# PostgreSQL flexible server

variable "pgsql_version" {
  type        = string
  default     = "11"
  description = "(Optional) The version of PostgreSQL Flexible Server to use. Possible values are 11,12, 13, 14 and 15. Required when create_mode is Default"
}

variable "sku_name" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "(Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3)."
}

variable "storage_mb" {
  type        = number
  default     = 32768
  description = "(Optional) The storage capacity of the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "storage_tier" {
  type        = string
  default     = "P10"
  description = <<EOF
  (Optional) The name of storage performance tier for IOPS of the PostgreSQL Flexible Server. Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80.
  The value is dependant of the storage_mb, please check this documentation
  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server#storage_tier-defaults-based-on-storage_mb"
  EOF
}

variable "auto_grow_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Specifies whether or not the PostgreSQL Flexible Server should automatically grow storage. Defaults to true."
}

# Network configuration

variable "vnet_integration_enable" {
  type        = bool
  default     = true
  description = "(for data source) The name of the virtual network subnet to create the PostgreSQL Flexible Server. The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}


variable "psql_subnet_name" {
  type        = string
  default     = null
  description = "(for data source) The name of the virtual network subnet to create the PostgreSQL Flexible Server. It can be a PE subnet or a delegated subnet. In case the provided subnet will be delegated, it should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "virtual_network_name" {
  type        = string
  default     = null
  description = "(for data source) The name of the virtual network to create the PostgreSQL Flexible Server. The provided virtual network should not have any other resource deployed in it and this virtual network will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "virtual_network_rg" {
  type        = string
  default     = null
  description = "(for data source) The name of the virtual network resource group to create the PostgreSQL Flexible Server. The provided virtual network should not have any other resource deployed in it and this virtual network will be delegated to the PostgreSQL Flexible Server, if not already delegated. Changing this forces a new PostgreSQL Flexible Server to be created."
}

# Authentication configuration

variable "active_directory_auth_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Specifies whether or not the PostgreSQL Flexible Server should allow Entra ID authentication. Defaults to false."
}


variable "route_table_name" {
  type        = string
  default     = null
  description = "(Optional) Specifies whether the module should create the default routes in the route table for Entra ID authentication. Leave it null if the routes have already been added"

}

variable "password_auth_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether or not the PostgreSQL Flexible Server should allow Local password authentication. Defaults to false."
}


variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this PostgreSQL Flexible Server. The only possible value is UserAssigned."
}

variable "identity_names" {
  type        = list(string)
  default     = []
  description = "The names of the User Managed Identities to associate with the PostgreSQL Flexible Server."
}

# High availability configuration

variable "high_availability_required" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether or not the PostgreSQL Flexible Server should be high available. Defaults to false."
}

variable "high_availability_mode" {
  type        = string
  default     = "ZoneRedundant"
  description = "(Required) The high availability mode for the PostgreSQL Flexible Server. Possible value are SameZone or ZoneRedundant"
}

# Backup configuration

variable "backup_retention_days" {
  type        = number
  default     = 7
  description = "(Optional) The number of days backups should be retained for. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether or not backups should be geo-redundant. Defaults to false."

}


#-------------------------------------#
# PostgreSQL flexible server database #
#-------------------------------------#

variable "postgresql_flexible_server_databases" {
  type = map(object({
    database_name = string
  }))

  default     = {}
  description = "(Optional) A map of databases which should be created on the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
}
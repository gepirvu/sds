# Generic

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "The default location where the mysql server will be created"
  default     = "westeurope"
}

variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "prj"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' for prod or 'np' for nonprod"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

# MySQL configuration

variable "mysql_version" {
  type        = string
  description = "(Required) The version of MySQL to use. Valid values are 5.7 and 8.0."
}

variable "sku_name" {
  type        = string
  description = "(Required) The SKU name of the MySQL server."
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "(Required) Enable Geo-redundant backups."
}

variable "storage" {
  type = object({
    auto_grow_enabled  = bool
    io_scaling_enabled = bool
    iops               = number
    size_gb            = number
  })
  description = "(Required) The storage configuration of the MySQL server."
}

variable "databases" {
  type        = map(map(string))
  description = "(Required) The databases to create on the MySQL server."
}

variable "maintenance_window" {
  type = object({
    day_of_week  = number
    start_hour   = number
    start_minute = number
  })
  description = "(Required) The maintenance window configuration of the MySQL server."
}

variable "allowed_cidrs" {
  type        = map(string)
  description = "(Required) The allowed CIDRs to access the MySQL server."
}

variable "administrator_login" {
  type        = string
  description = "(Required) The administrator login of the MySQL server."
}

variable "mysql_aad_group" {
  type        = string
  description = "(Required) The Azure AD group name of the MySQL administrator."
}

variable "umid_name" {
  type        = string
  description = "(Required) The name of the user-assigned managed identity."
}

variable "admin_password_expiration_date" {
  type        = string
  description = "(Required) The expiration date of the administrator password."
}

variable "key_vault_name" {
  type        = string
  description = "(Required) The name of the key vault."
}

variable "mysql_options" {
  type = object({
    audit_log_enabled = string
  })
}

variable "high_availability_mode" {
  type = object({
    mode = string
  })
}

variable "delegated_subnet_details" {
  description = "Details of the subnet to create the MySQL Flexible Server.Be sure to delegate the subnet to Microsoft.DBforMySQL/flexibleServers resource provider."
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
  default = null
}

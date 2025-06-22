| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_mysql_flexible_server?repoName=azurerm_mysql_flexible_server&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2558&repoName=azurerm_mysql_flexible_server&branchName=main) | **v1.3.14** | 25/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  


# INDEX
-------

1. [Azure MySQL flexible server Configuration](#azure-mysql-flexible-server-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure MySQL flexible server Configuration
-------------------------------------------

[Learn more about Azure Event Hub in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview)

## Service Description
----------------------

Azure Database for MySQL flexible server is cost effective and easy to set up, operate, and scale. Enjoy advanced security, same-zone or zone-redundant high availability, and a service-level agreement (SLA) of up to 99.99 percent. Leverage your existing open source MySQL skills, tools, drivers, and programming languages of your choice. Achieve faster innovation and increased productivity with a simplified end-to-end deployment experience and take advantage of new flexible server features such as, user-controlled maintenance windows, server parameter configuration, and IOPS provisioning.

## Deployed Resources
---------------------

This module will deploy the following azurerm resources:

- azurerm_mysql_flexible_server
- azurerm_mysql_flexible_server_active_directory_administrator
- azurerm_mysql_flexible_database
- azurerm_mysql_flexible_server_configuration
- azurerm_mysql_flexible_server_firewall_rule
- azurerm_key_vault_secret

## Pre-requisites
-----------------

It is assumed that the following resources already exists:

- Resource Group
- Delegated mysql subnet
- Key Vault to store MySQL credentials
- User assigned managed identity (optional)
- Active directory group (optional)

## Axso Naming convention example
---------------------------------

The naming convention is derived from the following variables subscription, project_name, environment:

**Construct MySQL flexible server name:** `axso-${var.subscription}-appl-${var.project_name}-${var.environment}-mysqldb`

**NonProd:** axso-np-appl-cloudinfra-dev-mysqldb

**Prod:** axso-p-appl-cloudinfra-prod-mysqldb

# Terraform Files
-----------------

## module.tf

```hcl
module "axso_mysql_flexible_server" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_mysql_flexible_server?ref=v1.3.14"

  # Generic
  resource_group_name = var.resource_group_name
  location            = var.location
  project_name        = var.project_name
  subscription        = var.subscription
  environment         = var.environment

  # SQL server configuration
  mysql_version = var.mysql_version
  sku_name      = var.sku_name

  # Authentication
  administrator_login                           = var.administrator_login
  mysql_administrator_group                     = var.mysql_aad_group
  administrator_password_expiration_date_secret = var.admin_password_expiration_date
  user_assigned_identity_name                   = var.umid_name
  key_vault_name                                = var.key_vault_name

  # Storage
  storage = var.storage

  # Backup and restore configuration
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  # Network
  delegated_subnet_details = var.delegated_subnet_details
  allowed_cidrs            = var.allowed_cidrs

  # Maintenance window
  maintenance_window = var.maintenance_window

  mysql_options = var.mysql_options

  # High availability configuration
  high_availability = var.high_availability_mode 

  # Databases
  databases = var.databases
}
```

## module.tf.tfvars

```hcl
# Generic

resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"
project_name        = "cloudinfra"
subscription        = "np"
environment         = "dev"

# MySQL configuration

mysql_version                = "8.0.21"
sku_name                     = "GP_Standard_D2ds_v4"
geo_redundant_backup_enabled = false

storage = {
  auto_grow_enabled  = true
  io_scaling_enabled = false
  iops               = 360
  size_gb            = 20
}

databases = {
  "documents" = {
    charset   = "utf8mb3"
    collation = "utf8mb3_general_ci"
  }
}

maintenance_window = {
  day_of_week  = 0
  start_hour   = 0
  start_minute = 0
}

delegated_subnet_details = {
  vnet_rg_name = "axso-np-appl-ssp-test-rg"
  vnet_name    = "vnet-ssp-nonprod-axso-vnet"
  subnet_name  = "mysql-subnet"
}

allowed_cidrs = {
  "onprem" = "10.0.0.0/24"
}

# Authentication
administrator_login            = "sqladmin"
mysql_aad_group                = null                         # Mention the AAD group name if you want to enable AAD authentication
umid_name                      = "axso-np-appl-ssp-test-umid" # can be empty string "" if not needed
admin_password_expiration_date = "2025-12-06T02:03:00Z"
key_vault_name                 = "kv-ssp-0-nonprod-axso"

mysql_options = {
  audit_log_enabled = "ON"
}

high_availability_mode = {
  mode = "SameZone"
}
```

## variables.tf

```hcl
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
}
```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.mysql_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_mysql_flexible_database.mysql_flexible_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) | resource |
| [azurerm_mysql_flexible_server.mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_mysql_flexible_server_active_directory_administrator.mysql_flexible_server_active_directory_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_active_directory_administrator) | resource |
| [azurerm_mysql_flexible_server_configuration.mysql_flexible_server_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration) | resource |
| [azurerm_mysql_flexible_server_firewall_rule.firewall_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule) | resource |
| [random_password.mysql_administrator_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_group.mysql_administrator_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | MySQL administrator login | `string` | n/a | yes |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | MySQL administrator password. If not set, a random password will be generated and stored in the key vault. | `string` | `null` | no |
| <a name="input_administrator_password_expiration_date_secret"></a> [administrator\_password\_expiration\_date\_secret](#input\_administrator\_password\_expiration\_date\_secret) | The expiration day of the mysql password secret | `string` | n/a | yes |
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | Map of authorized CIDRs | `map(string)` | `{}` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Backup retention days for the server, supported values are between `7` and `35` days. | `number` | `10` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The creation mode which can be used to restore or replicate existing servers. | `string` | `"Default"` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | Map of databases with default collation and charset. | `map(map(string))` | n/a | yes |
| <a name="input_delegated_subnet_details"></a> [delegated\_subnet\_details](#input\_delegated\_subnet\_details) | Details of the subnet to create the MySQL Flexible Server.Be sure to delegate the subnet to Microsoft.DBforMySQL/flexibleServers resource provider. | <pre>object({<br/>    subnet_name  = string<br/>    vnet_name    = string<br/>    vnet_rg_name = string<br/>  })</pre> | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | Turn Geo-redundant server backups on/off. Not available for the Burstable tier. | `bool` | `false` | no |
| <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability) | Map of high availability configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability. `null` to disable high availability | <pre>object({<br/>    mode                      = string<br/>    standby_availability_zone = optional(number)<br/>  })</pre> | <pre>{<br/>  "mode": "ZoneRedundant",<br/>  "standby_availability_zone": 2<br/>}</pre> | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the key vault to store the MySQL administrator password. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the resource will be created | `string` | `"westeurope"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Map of maintenance window configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-maintenance | `map(number)` | `null` | no |
| <a name="input_mysql_administrator_group"></a> [mysql\_administrator\_group](#input\_mysql\_administrator\_group) | AD Group to associate with the MySQL Flexible Server. | `string` | `null` | no |
| <a name="input_mysql_options"></a> [mysql\_options](#input\_mysql\_options) | Map of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters. | `map(string)` | `{}` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | MySQL server version. Valid values are `5.7` and `8.0.21` | `string` | `"8.0.21"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"prj"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU Name for the MySQL Flexible Server. NOTE: sku\_name should start with SKU tier B (Burstable), GP (General Purpose), MO (Memory Optimized) like B\_Standard\_B1s. | `string` | `"GP_Standard_D2ads_v5"` | no |
| <a name="input_source_server_id"></a> [source\_server\_id](#input\_source\_server\_id) | The resource ID of the source MySQL Flexible Server to be restored. | `string` | `null` | no |
| <a name="input_ssl_enforced"></a> [ssl\_enforced](#input\_ssl\_enforced) | Enforce SSL connection on MySQL provider and set require\_secure\_transport on MySQL Server | `bool` | `true` | no |
| <a name="input_storage"></a> [storage](#input\_storage) | Map of the storage configuration | <pre>object({<br/>    auto_grow_enabled  = optional(bool)<br/>    io_scaling_enabled = optional(bool)<br/>    iops               = optional(number)<br/>    size_gb            = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name) | The name of the user assigned identity to associate with the MySQL Flexible Server. You have to ask the infra team to add you permissions to the identity.https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad#grant-permissions-to-user-assigned-managed-identity | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3 | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysql_flexible_database_ids"></a> [mysql\_flexible\_database\_ids](#output\_mysql\_flexible\_database\_ids) | The list of all database resource IDs |
| <a name="output_mysql_flexible_databases"></a> [mysql\_flexible\_databases](#output\_mysql\_flexible\_databases) | Map of databases infos |
| <a name="output_mysql_flexible_databases_names"></a> [mysql\_flexible\_databases\_names](#output\_mysql\_flexible\_databases\_names) | List of databases names |
| <a name="output_mysql_flexible_firewall_rule_ids"></a> [mysql\_flexible\_firewall\_rule\_ids](#output\_mysql\_flexible\_firewall\_rule\_ids) | Map of MySQL created firewall rules |
| <a name="output_mysql_flexible_fqdn"></a> [mysql\_flexible\_fqdn](#output\_mysql\_flexible\_fqdn) | FQDN of the MySQL server |
| <a name="output_mysql_flexible_server_id"></a> [mysql\_flexible\_server\_id](#output\_mysql\_flexible\_server\_id) | MySQL server ID |
| <a name="output_mysql_flexible_server_name"></a> [mysql\_flexible\_server\_name](#output\_mysql\_flexible\_server\_name) | MySQL server name |
<!-- END_TF_DOCS -->

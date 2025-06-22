| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|----------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_redis_cache?repoName=azurerm_redis_cache&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=3147&repoName=azurerm_redis_cache&branchName=main) | **v1.1.1** | **28/11/2024** |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

-------

1. [Azure Cache for Redis](#azure-cache-for-redis)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Cache for Redis

-----------------------

[Learn more about Azure Cache for Redis in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------

Azure Cache for Redis provides an in-memory data store based on the Redis software. Redis improves the performance and scalability of an application that uses backend data stores heavily. It's able to process large volumes of application requests by keeping frequently accessed data in the server memory, which can be written to and read from quickly. Redis brings a critical low-latency and high-throughput data storage solution to modern applications.

Azure Cache for Redis offers both the Redis open-source (OSS Redis) and a commercial product from Redis Inc. (Redis Enterprise) as a managed service. It provides secure and dedicated Redis server instances and full Redis API compatibility. Microsoft operates the service, hosted on Azure, and usable by any application within or outside of Azure.

Azure Cache for Redis can be used as a distributed data or content cache, a session store, a message broker, and more. It can be deployed standalone. Or, it can be deployed along with other Azure database services, such as Azure SQL or Azure Cosmos DB.

## Deployed Resources

---------------------

This module will deploy the following azurerm resources:

- azurerm_redis_cache
- azurerm_redis_firewall_rule
- azurerm_private_endpoint

## Pre-requisites

-----------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Private Endpoint

## Axso Naming convention example

---------------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment`:

- **Construct:** `axso-${var.subscription}-appl-${var.project_name}-${var.environment}-redis-cache`  
- **NonProd:** `axso-np-appl-ci-lab-redis-cache`
- **Prod:** `axso-p-appl-ci-prod-redis-cache`

# Terraform Files

-----------------

## module.tf

```hcl
module "axso_redis_cache" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_redis_cache?ref=v1.1.1"

  # General
  resource_group_name = var.resource_group_name
  location            = var.location

  # Naming Convention
  subscription = var.subscription
  project_name = var.project_name
  environment  = var.environment

  # Pricing
  capacity = var.capacity
  family   = var.family
  sku_name = var.sku_name

  # Network
  pe_subnet_details    = var.pe_subnet_details
  redis_fw_rules       = var.redis_fw_rules

  # Patching - The Patch Window lasts for 5 hours from the start_hour_utc.
  enable_patching = var.enable_patching
  day_of_week     = var.enable_patching ? var.day_of_week : null
  start_hour_utc  = var.enable_patching ? var.start_hour_utc : null

  # Authentication
  access_keys_authentication_enabled = var.access_keys_authentication_enabled
  identity_type                      = var.identity_type
  redis_umids                        = var.redis_umids
}
```

## module.tf.tfvars

```hcl
# Prerequisites and general                                                                                         

resource_group_name = "axso-np-appl-ssp-test-rg"

location = "westeurope"

project_name = "ci"

subscription = "np"

environment = "lab"


# Redis cache                                                                                                             

### Redis Cache - Pricing ###

# C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6
# P (Premium) are 1, 2, 3, 4, 5.

capacity = 1
family   = "C"
sku_name = "Standard"

### Redis Cache - Network ###

# Private Endpoint

pe_subnet_details = {
  subnet_name  = "app-conf-pe-subnet"
  vnet_name    = "vnet-ssp-nonprod-axso-vnet"
  vnet_rg_name = "axso-np-appl-ssp-test-rg"
}

# Firewall Rules

redis_fw_rules = {
  "test-rule-1" = {
    name     = "test_rule_1"    # "name" may only contain alphanumeric characters and underscores.
    start_ip = "192.168.1.1"
    end_ip   = "192.168.1.2"
  },
  "test-rule-2" = {
    name     = "test_rule_2"    # "name" may only contain alphanumeric characters and underscores.
    start_ip = "192.168.1.3"
    end_ip   = "192.168.1.4"
  }
}

### Redis Cache - Patching schedule ###

enable_patching = true
day_of_week     = "Sunday"
start_hour_utc  = 6

### Redis Cache - Authentication ###

active_directory_authentication_enabled = false # Only applicable for Premium SKU.

access_keys_authentication_enabled = true # Can only be disabled when SKU is Premium and active_directory_authentication_enabled is true.

identity_type = "UserAssigned"

redis_umids = {
  umid-1 = {
    umid_name    = "axso-np-appl-ssp-test-umid"
    umid_rg_name = "axso-np-appl-ssp-test-rg"
  },
  umid-2 = {
    umid_name    = "axso-np-appl-ssp-test-umid2"
    umid_rg_name = "axso-np-appl-ssp-test-rg"
  }
}
```

## variables.tf

```hcl
# Prerequsites and general                                                                                          

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

# Naming Convention

variable "project_name" {
  type        = string
  default     = "cloudinfra"
  description = "The name of the project. e.g. MDS, cloudinfra, cp, cpm etc.. etc.."
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

# Redis cache                                                                                                           

### Redis Cache - Pricing ###

variable "capacity" {
  type        = number
  default     = 1
  description = "(Optional) The size of the Redis cache to deploy. Valid values are 0, 1, 2, 3, 4, 5, 6. Defaults to 1."
}

variable "family" {
  type        = string
  default     = "C"
  description = "(Optional) The SKU family to use. Valid values are C (for Basic/Standard instances) and P (for Premium instances). Defaults to C."
}

variable "sku_name" {
  type        = string
  default     = "Basic"
  description = "(Optional) The SKU of Redis to use. Valid values are Basic, Standard and Premium. Defaults to Basic."
}

### Redis Cache - Patching ###

variable "enable_patching" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not the Redis instance should be patched. Defaults to false."
}

variable "day_of_week" {
  type        = string
  default     = "Sunday"
  description = "(Optional) The day of the week when a cache can be patched. Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday."
}

variable "start_hour_utc" {
  type        = number
  default     = 0
  description = "(Optional) The start hour after which cache patching can start. Possible values are 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11."
}

### Redis cache - Networking ###

variable "pe_subnet_details" {
  description = "The details of the subnet to use for the private endpoint of the Redis cache."
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
  default = null
}

variable "redis_fw_rules" {
  type        = map(object({
    name     = string
    start_ip = string
    end_ip   = string
  }))
  default     = null
  description = "(Optional) A map of firewall rules to apply to the Redis instance. Each rule should have a name, start_ip and end_ip."
}

### Redis Cache - Authentication ###

variable "active_directory_authentication_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not Azure Active Directory authentication is enabled for this Redis instance. Defaults to false."
}

variable "access_keys_authentication_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not access keys are enabled for this Redis instance. Defaults to true."
}

variable "identity_type" {
  type        = string
  default     = null
  description = "(Optional) The type of Managed Service Identity to use. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
}

variable "redis_umids" {
  description = "The User Managed Identities to use for the Redis cache."
  type = map(object({
    umid_name    = string
    umid_rg_name = string
  }))
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
      version = "4.11.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azuread" {}
```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_redis_cache.redis_cache](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_redis_firewall_rule.fw_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_firewall_rule) | resource |
| [azurerm_subnet.pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_keys_authentication_enabled"></a> [access\_keys\_authentication\_enabled](#input\_access\_keys\_authentication\_enabled) | (Optional) Whether or not access keys are enabled for this Redis instance. Defaults to true. | `bool` | `false` | no |
| <a name="input_active_directory_authentication_enabled"></a> [active\_directory\_authentication\_enabled](#input\_active\_directory\_authentication\_enabled) | (Optional) Whether or not Azure Active Directory authentication is enabled for this Redis instance. Defaults to false. | `bool` | `true` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | (Optional) The size of the Redis cache to deploy. Valid values are 0, 1, 2, 3, 4, 5, 6. Defaults to 1. | `number` | `1` | no |
| <a name="input_day_of_week"></a> [day\_of\_week](#input\_day\_of\_week) | (Optional) The day of the week when a cache can be patched. Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday. | `string` | `"Sunday"` | no |
| <a name="input_enable_patching"></a> [enable\_patching](#input\_enable\_patching) | (Optional) Whether or not the Redis instance should be patched. Defaults to false. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_family"></a> [family](#input\_family) | (Optional) The SKU family to use. Valid values are C (for Basic/Standard instances) and P (for Premium instances). Defaults to C. | `string` | `"C"` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Optional) The type of Managed Service Identity to use. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned. | `string` | `"SystemAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"westeurope"` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | (Optional) The minimum TLS version. Defaults to 1.2. | `string` | `"1.2"` | no |
| <a name="input_non_ssl_port_enabled"></a> [non\_ssl\_port\_enabled](#input\_non\_ssl\_port\_enabled) | (Optional) Whether or not the non-ssl Redis server port (6379) is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_pe_subnet_details"></a> [pe\_subnet\_details](#input\_pe\_subnet\_details) | n/a | <pre>object({<br>    subnet_name  = string<br>    vnet_name    = string<br>    vnet_rg_name = string<br>  })</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether or not public access is allowed for this Redis instance. Defaults to true. | `bool` | `false` | no |
| <a name="input_redis_fw_rules"></a> [redis\_fw\_rules](#input\_redis\_fw\_rules) | n/a | <pre>map(object({<br>    name     = string<br>    start_ip = string<br>    end_ip   = string<br>  }))</pre> | n/a | yes |
| <a name="input_redis_umids"></a> [redis\_umids](#input\_redis\_umids) | n/a | <pre>map(object({<br>    umid_name    = string<br>    umid_rg_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU of Redis to use. Valid values are Basic, Standard and Premium. Defaults to Standard. | `string` | `"Standard"` | no |
| <a name="input_start_hour_utc"></a> [start\_hour\_utc](#input\_start\_hour\_utc) | (Optional) The start hour after which cache patching can start. Possible values are 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11. | `number` | `0` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Redis. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Redis. |
<!-- END_TF_DOCS -->

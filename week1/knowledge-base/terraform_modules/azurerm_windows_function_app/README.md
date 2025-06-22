| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_windows_function_app?repoName=azurerm_windows_function_app&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=3732&repoName=azurerm_windows_function_app&branchName=main) | **v1.0.1** | 11/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**

# INDEX

----------------------------

1. [Windows Function App Configuration](#windows-function-app-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Windows Function App Configuration

----------------------------

[Learn more about Function Apps in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/azure-functions/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure Function Apps is a serverless compute service provided by Microsoft Azure that allows you to run small pieces of code, or "functions," in response to events without managing infrastructure. It supports various programming languages like C#, JavaScript, Python, and more, enabling you to develop and deploy event-driven applications with minimal overhead. Function Apps automatically scale based on demand and integrate with numerous Azure services, making them ideal for scenarios such as data processing, automation, and real-time data stream handling.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_service_plan
- azurerm_function_app
- azurerm_private_endpoint

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Virtual Network
- Subnet (For private endpoint)
- Storage Account
- Private DNS Zone
- User Managed Identity

## Axso Naming convention example

---------------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment` and `usecase`:

> Function App name must be globaly unique.

- **Construct - App Service Plan:** `axso-${var.subscription}-appl-${var.project_name}-${var.environment}-asp`  
- **Construct - Function App:** `axso-${var.subscription}-appl-${var.project_name}-${var.environment}-func-${var.usecase}`

## App Service Plan

- **NonProd:** `axso-np-appl-cloud-dev-asp`
- **Prod:** `axso-p-appl-cloud-prod-asp`

## Function App (Max 32 Characters long)

- **NonProd:** `axso-np-appl-cloud-dev-func-usecase`
- **Prod:** `axso-p-appl-cloud-prod-func-usecase`

# Terraform Files

----------------------------

## module.tf

```hcl
module "windows_function_apps" {

  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_windows_function_app?ref=v1.0.1"

  # General

  resource_group_name = var.resource_group_name
  location            = var.location

  # Naming Convention

  project_name = var.project_name
  subscription = var.subscription
  environment  = var.environment

  # App Service Plan

  sku_name               = var.sku_name
  zone_balancing_enabled = var.zone_balancing_enabled
  worker_count           = var.worker_count

  # Function Apps

  function_app                        = var.function_app
  storage_account_name                = var.storage_account_name
  storage_account_resource_group_name = var.storage_account_resource_group_name
  https_only                          = var.https_only
  vnet_integration_subnet_name        = var.vnet_integration_subnet_name
  public_network_access_enabled       = var.public_network_access_enabled

  # Private Endpoint

  pe_subnet_name              = var.pe_subnet_name
  network_name                = var.network_name
  network_resource_group_name = var.network_resource_group_name
}

```

## module.tf.tfvars

```hcl
# General

resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"
project_name        = "cloudinfra"
subscription        = "np"
environment         = "dev"

# App Service Plan

sku_name               = "P1v2"
zone_balancing_enabled = false
worker_count           = 1

# Function App

storage_account_name                = "axso4p4ssp4np4testsa"
storage_account_resource_group_name = "axso-np-appl-ssp-test-rg"
https_only                          = true
public_network_access_enabled       = false
vnet_integration_subnet_name        = "app-windows-subnet"

function_app = [
  {
    usecase = "java"
  },
  {
    usecase = "script"
  }
]

# Private Endpoint

pe_subnet_name              = "pe"
network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"

```

## variables.tf

```hcl

# Common Variables

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "The Azure location where the resources will be deployed."
  type        = string
  default     = "West Europe"
}

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

# Data Source Variables

variable "storage_account_name" {
  description = "The name of the Storage Account to be created or used."
  type        = string
}

variable "storage_account_resource_group_name" {
  description = "The name of the resource group where the Storage Account is located."
  type        = string
}

variable "pe_subnet_name" {
  description = "The name of the subnet within the virtual network where the storage account resides."
  type        = string
}

variable "network_name" {
  description = "The name of the virtual network to which the subnet belongs."
  type        = string
}

variable "network_resource_group_name" {
  description = "The name of the resource group where the virtual network is located."
  type        = string
}

# App Service Plan Variables

variable "sku_name" {
  description = "The SKU (pricing tier) of the App Service Plan."
  type        = string
}

variable "zone_balancing_enabled" {
  description = "Should the Service Plan balance across Availability Zones in the region. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "worker_count" {
  description = "The number of Workers (instances) to be allocated."
  type        = number
  default     = 1
}


# Function App Variables

variable "function_app" {
  description = "The Function App variable block. 'usecase' variable will determine the naming of the Function App"
  type = list(object({
    usecase = string
  }))
}

variable "https_only" {
  description = "The name of the virtual network to which the subnet belongs."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enables or Disables public access to the Function App."
  type        = bool
  default     = false
}

variable "vnet_integration_subnet_name" {
  description = "The ID of the subnet for Virtual Network Integration"
  type        = string
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
      version = "= 4.20.0"
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_service_plan.app_service_function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_windows_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.vint_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_function_app"></a> [function\_app](#input\_function\_app) | The Function App variable block. 'usecase' variable will determine the naming of the Function App | <pre>list(object({<br/>    usecase = string<br/>  }))</pre> | n/a | yes |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | The name of the virtual network to which the subnet belongs. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure location where the resources will be deployed. | `string` | `"West Europe"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the virtual network to which the subnet belongs. | `string` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The name of the resource group where the virtual network is located. | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet within the virtual network where the storage account resides. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enables or Disables public access to the Function App. | `bool` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the resources. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU (pricing tier) of the App Service Plan. | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the Storage Account to be created or used. | `string` | n/a | yes |
| <a name="input_storage_account_resource_group_name"></a> [storage\_account\_resource\_group\_name](#input\_storage\_account\_resource\_group\_name) | The name of the resource group where the Storage Account is located. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |
| <a name="input_vnet_integration_subnet_name"></a> [vnet\_integration\_subnet\_name](#input\_vnet\_integration\_subnet\_name) | The name of the subnet which the function app will use as virtual network integrated. | `string` | n/a | yes |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | The number of Workers (instances) to be allocated. | `number` | n/a | yes |
| <a name="input_zone_balancing_enabled"></a> [zone\_balancing\_enabled](#input\_zone\_balancing\_enabled) | Should the Service Plan balance across Availability Zones in the region. Changing this forces a new resource to be created. | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_app_default_hostnames"></a> [function\_app\_default\_hostnames](#output\_function\_app\_default\_hostnames) | Output for function app default\_hostname |
| <a name="output_function_app_ids"></a> [function\_app\_ids](#output\_function\_app\_ids) | Output for function app id |
| <a name="output_function_app_names"></a> [function\_app\_names](#output\_function\_app\_names) | Output for function app name |
<!-- END_TF_DOCS -->

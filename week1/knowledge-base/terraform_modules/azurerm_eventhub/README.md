| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_eventhub?repoName=azurerm_eventhub&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2321&repoName=azurerm_eventhub&branchName=main) | **v1.1.5** | 25/03/2025 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Event Hub Configuration](#azure-event-hub-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Event Hub Configuration

----------------------------

[Learn more about Azure Event Hub in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure Event Hubs is a cloud native data streaming service that can stream millions of events per second, with low latency, from any source to any destination. Event Hubs is compatible with Apache Kafka, and it enables you to run existing Kafka workloads without any code changes.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_eventhub_namespace
- azurerm_eventhub
- azurerm_private_endpoint

## Pre-requisites
-----------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Private endpoint deployment

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables subscription, project_name, environment:

**Construct EventHub Namespace:** `axso-${var.subscription}-appl-${var.project_name}-${var.environment}-ehub-ns`

**Construct EventHub:** `axso-${var.subscription}-appl-${var.project_name}-${var.environment}-ehub`

**NonProd:** axso-np-appl-cloudinfra-dev-app-ehub-ns / axso-np-appl-cloudinfra-dev-ehub

**Prod:** axso-p-appl-cloudinfra-prod-ehub-ns / axso-p-appl-cloudinfra-prod-ehub

# Terraform Files

----------------------------

## module.tf

```hcl
module "azurerm_eventhub" {
  source                      = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_eventhub?ref=v1.1.5"
  project_name                = var.project_name
  subscription                = var.subscription
  environment                 = var.environment
  location                    = var.location
  resource_group_name         = var.resource_group_name
  partition_count             = var.partition_count
  message_retention           = var.message_retention
  virtual_network_name        = var.virtual_network_name
  network_resource_group_name = var.network_resource_group_name
  pe_subnet_name              = var.pe_subnet_name
}
```

## module.tf.tfvars

```hcl

location                    = "West Europe"
environment                 = "dev"
project_name                = "ssp"
subscription                = "np"
resource_group_name         = "axso-np-appl-ssp-test-rg"
partition_count             = 2
message_retention           = 1
network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name        = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name              = "pe"

```

## variables.tf

```hcl

## Common

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Specifies azure region/location where resources will be created."
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where Monitor Workspace will be deployed."
}

## EventHub Variables

variable "partition_count" {
  type        = number
  description = "The name of the Resource Group where Monitor Workspace will be deployed."
}

variable "message_retention" {
  type        = number
  description = "The name of the Resource Group where Monitor Workspace will be deployed."
}

## Subnet Data Source

variable "pe_subnet_name" {
  type        = string
  description = "The name of the Resource Group where the private endpoint subnet is deployed."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the Virtual Network hosting the private endpoint subnet."
}

variable "network_resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the Virtual Network is located."
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.6 |
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
| [azurerm_eventhub.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.eventhub_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_subnet.eventhub_pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies azure region/location where resources will be created. | `string` | `"westeurope"` | no |
| <a name="input_message_retention"></a> [message\_retention](#input\_message\_retention) | The name of the Resource Group where Monitor Workspace will be deployed. | `number` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The name of the Resource Group where the Virtual Network is located. | `string` | n/a | yes |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | The name of the Resource Group where Monitor Workspace will be deployed. | `number` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the Resource Group where the private endpoint subnet is deployed. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where Monitor Workspace will be deployed. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | `"np"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the Virtual Network hosting the private endpoint subnet. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

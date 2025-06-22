| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_eventgrid?repoName=azurerm_eventgrid&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=4150&repoName=azurerm_eventgrid&branchName=main) | **v1.0.1** | 23/12/2024 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  


# INDEX
----------------------------

1. [Event Grid Domain Configuration](#event-grid-domain-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)


# Event Grid Domain Configuration
----------------------------

[Learn more about Event Grid Domains](https://learn.microsoft.com/en-us/azure/event-grid/event-domains)

## Service Description
----------------------------

Azure Event Grid is a highly scalable, event-based service that enables real-time event processing and integration across multiple services and platforms. It allows developers to create event-driven architectures, enabling applications to react to events as they occur, without requiring the need for polling or continuous monitoring. With Event Grid, you can integrate with Azure services such as Azure Functions, Logic Apps, and Azure Storage, as well as non-Azure services like webhooks, REST APIs, and messaging queues. By providing a flexible and scalable eventing platform, Event Grid enables businesses to build more agile, responsive, and resilient applications that meet the demands of modern digital transformation.

In Azure Event Grid, a domain is a logical container that represents a specific namespace or scope for events. An event grid domain is a way to organize and categorize events into different topics, enabling you to define event handlers and subscriptions for specific domains.

> NOTE:
> This module is only able to deploy storage queue and webhook subscription types.

## Deployed Resources:
---------------------------

These all resources will be deployed when using Eventgrid Domains module.


- azurerm_eventgrid_domain
- azurerm_private_endpoint  
- azurerm_eventgrid_domain_topic  
- azurerm_eventgrid_event_subscription

## Pre-requisites
----------------------------

- Resource Group
- Virtual Network
- A subnet for the private endpoints to be deployed to


## Axso Naming convention example
----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.eventgrid_domain_purpose}-egd"`  
**NonProd:** `axso-np-appl-project-dev-internal-egd` 
**Prod:** `axso-p-appl-project-prod-internal-egd`


# Terraform Files
----------------------------

## module.tf

```hcl

module "azurerm_eventgrid_domains" {
  source                              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_eventgrid?ref=v1.0.1"
  subscription                        = var.subscription
  project_name                        = var.project_name
  environment                         = var.environment
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  virtual_network_name                = var.virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  pe_subnet_name                      = var.pe_subnet_name
  eventgrid_domain_config             = var.eventgrid_domain_config
}

```

## module.tf.tfvars  

```hcl
project_name        = "cloudinfra"
subscription        = "np"
environment         = "dv"
resource_group_name = "axso-np-appl-ssp-test-rg"
location            = "westeurope"


virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
pe_subnet_name                      = "pe"

eventgrid_domain_config = [
  {
    eventgrid_domain_purpose = "testdomain1"
    event_schema             = "CloudEventSchemaV1_0"
    system_assigned_identity = true
    topics = [
      {
        topic_name    = "testdomain1topic1"
        subscriptions = []
      }
    ]
  },
  {
    eventgrid_domain_purpose = "testdomain2"
    event_schema             = "CloudEventSchemaV1_0"
    system_assigned_identity = true
    topics = [
      {
        topic_name    = "testdomain2topic1"
        subscriptions = []
      }
    ]
  }
]

```

## variables.tfvars

```hcl


variable "subscription" {
  type        = string
  description = "The Axso environment subscription e.g. 'p' for production or 'np' for non-production"
  default     = "np"
}

variable "project_name" {
  type        = string
  description = "The Axso project name e.g. 'etools'"
  default     = "etools"
}

variable "environment" {
  type        = string
  description = "The Axso environment e.g. 'dev', 'test', 'prod'"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The Azure region where the resource group will be created"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Azure resources."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network for the Azure resources."
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Vnet resource group name"
}

variable "pe_subnet_name" {
  type        = string
  description = "Private endpoints subnet name"
}

variable "eventgrid_domain_config" {
  type = list(object({
    eventgrid_domain_purpose = string
    event_schema             = string
    system_assigned_identity = bool
    topics = list(object({
      topic_name = string
      subscriptions = list(object({
        webhooks = list(object({
          subscription_name                       = string
          url                                     = string
          max_events_per_batch                    = number
          preferred_batch_size_in_kilobytes       = number
          active_directory_tenant_id              = string
          active_directory_app_id_or_uri          = string
          dead_letter_identity_type               = string
          dead_letter_user_assigned_identity      = string
          dead_letter_storage_account_id          = string
          dead_letter_storage_blob_container_name = string
          subject_filters = list(object({
            subject_begins_with = string
            subject_ends_with   = string
            case_sensitive      = bool
          }))
          advanced_filters = list(object({
            bool_equals                   = list(object({ key = string, value = bool }))
            number_greater_than           = list(object({ key = string, value = number }))
            number_greater_than_or_equals = list(object({ key = string, value = number }))
            number_less_than              = list(object({ key = string, value = number }))
            number_less_than_or_equals    = list(object({ key = string, value = number }))
            number_in                     = list(object({ key = string, values = list(number) }))
            number_not_in                 = list(object({ key = string, values = list(number) }))
            number_in_range               = list(object({ key = string, values = list(number) }))
            number_not_in_range           = list(object({ key = string, values = list(number) }))
            string_begins_with            = list(object({ key = string, values = list(string) }))
            string_not_begins_with        = list(object({ key = string, values = list(string) }))
            string_ends_with              = list(object({ key = string, values = list(string) }))
            string_not_ends_with          = list(object({ key = string, values = list(string) }))
            string_contains               = list(object({ key = string, values = list(string) }))
            string_not_contains           = list(object({ key = string, values = list(string) }))
            string_in                     = list(object({ key = string, values = list(string) }))
            string_not_in                 = list(object({ key = string, values = list(string) }))
            is_not_null                   = list(object({ key = string }))
            is_null_or_undefined          = list(object({ key = string }))
          }))
        }))
        storage_queues = list(object({
          storage_account_id                      = string
          queue_name                              = string
          queue_message_time_to_live_in_seconds   = number
          dead_letter_identity_type               = string
          dead_letter_user_assigned_identity      = string
          dead_letter_storage_account_id          = string
          dead_letter_storage_blob_container_name = string
          subject_filters = list(object({
            subject_begins_with = string
            subject_ends_with   = string
            case_sensitive      = bool
          }))
          advanced_filters = list(object({
            bool_equals                   = list(object({ key = string, value = bool }))
            number_greater_than           = list(object({ key = string, value = number }))
            number_greater_than_or_equals = list(object({ key = string, value = number }))
            number_less_than              = list(object({ key = string, value = number }))
            number_less_than_or_equals    = list(object({ key = string, value = number }))
            number_in                     = list(object({ key = string, values = list(number) }))
            number_not_in                 = list(object({ key = string, values = list(number) }))
            number_in_range               = list(object({ key = string, values = list(number) }))
            number_not_in_range           = list(object({ key = string, values = list(number) }))
            string_begins_with            = list(object({ key = string, values = list(string) }))
            string_not_begins_with        = list(object({ key = string, values = list(string) }))
            string_ends_with              = list(object({ key = string, values = list(string) }))
            string_not_ends_with          = list(object({ key = string, values = list(string) }))
            string_contains               = list(object({ key = string, values = list(string) }))
            string_not_contains           = list(object({ key = string, values = list(string) }))
            string_in                     = list(object({ key = string, values = list(string) }))
            string_not_in                 = list(object({ key = string, values = list(string) }))
            is_not_null                   = list(object({ key = string }))
            is_null_or_undefined          = list(object({ key = string }))
          }))
        }))
      }))
    }))
  }))
  description = "Eventgrid domain configuration."
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
      version = "4.14.0"
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
| [azurerm_eventgrid_domain.eventgrid_domains](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_domain) | resource |
| [azurerm_eventgrid_domain_topic.eventgrid_domain_topics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_domain_topic) | resource |
| [azurerm_eventgrid_event_subscription.storage_queue_subscriptions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_event_subscription) | resource |
| [azurerm_eventgrid_event_subscription.webhook_subscriptions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_event_subscription) | resource |
| [azurerm_private_endpoint.eventgrid_domains_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_subnet.pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The Axso environment e.g. 'dev', 'test', 'prod' | `string` | `"dev"` | no |
| <a name="input_eventgrid_domain_config"></a> [eventgrid\_domain\_config](#input\_eventgrid\_domain\_config) | Eventgrid domain configuration. | <pre>list(object({<br/>    eventgrid_domain_purpose = string<br/>    event_schema             = string<br/>    system_assigned_identity = bool<br/>    topics = list(object({<br/>      topic_name = string<br/>      subscriptions = list(object({<br/>        webhooks = list(object({<br/>          subscription_name                       = string<br/>          url                                     = string<br/>          max_events_per_batch                    = number<br/>          preferred_batch_size_in_kilobytes       = number<br/>          active_directory_tenant_id              = string<br/>          active_directory_app_id_or_uri          = string<br/>          dead_letter_identity_type               = string<br/>          dead_letter_user_assigned_identity      = string<br/>          dead_letter_storage_account_id          = string<br/>          dead_letter_storage_blob_container_name = string<br/>          subject_filters = list(object({<br/>            subject_begins_with = string<br/>            subject_ends_with   = string<br/>            case_sensitive      = bool<br/>          }))<br/>          advanced_filters = list(object({<br/>            bool_equals                   = list(object({ key = string, value = bool }))<br/>            number_greater_than           = list(object({ key = string, value = number }))<br/>            number_greater_than_or_equals = list(object({ key = string, value = number }))<br/>            number_less_than              = list(object({ key = string, value = number }))<br/>            number_less_than_or_equals    = list(object({ key = string, value = number }))<br/>            number_in                     = list(object({ key = string, values = list(number) }))<br/>            number_not_in                 = list(object({ key = string, values = list(number) }))<br/>            number_in_range               = list(object({ key = string, values = list(number) }))<br/>            number_not_in_range           = list(object({ key = string, values = list(number) }))<br/>            string_begins_with            = list(object({ key = string, values = list(string) }))<br/>            string_not_begins_with        = list(object({ key = string, values = list(string) }))<br/>            string_ends_with              = list(object({ key = string, values = list(string) }))<br/>            string_not_ends_with          = list(object({ key = string, values = list(string) }))<br/>            string_contains               = list(object({ key = string, values = list(string) }))<br/>            string_not_contains           = list(object({ key = string, values = list(string) }))<br/>            string_in                     = list(object({ key = string, values = list(string) }))<br/>            string_not_in                 = list(object({ key = string, values = list(string) }))<br/>            is_not_null                   = list(object({ key = string }))<br/>            is_null_or_undefined          = list(object({ key = string }))<br/>          }))<br/>        }))<br/>        storage_queues = list(object({<br/>          storage_account_id                      = string<br/>          queue_name                              = string<br/>          queue_message_time_to_live_in_seconds   = number<br/>          dead_letter_identity_type               = string<br/>          dead_letter_user_assigned_identity      = string<br/>          dead_letter_storage_account_id          = string<br/>          dead_letter_storage_blob_container_name = string<br/>          subject_filters = list(object({<br/>            subject_begins_with = string<br/>            subject_ends_with   = string<br/>            case_sensitive      = bool<br/>          }))<br/>          advanced_filters = list(object({<br/>            bool_equals                   = list(object({ key = string, value = bool }))<br/>            number_greater_than           = list(object({ key = string, value = number }))<br/>            number_greater_than_or_equals = list(object({ key = string, value = number }))<br/>            number_less_than              = list(object({ key = string, value = number }))<br/>            number_less_than_or_equals    = list(object({ key = string, value = number }))<br/>            number_in                     = list(object({ key = string, values = list(number) }))<br/>            number_not_in                 = list(object({ key = string, values = list(number) }))<br/>            number_in_range               = list(object({ key = string, values = list(number) }))<br/>            number_not_in_range           = list(object({ key = string, values = list(number) }))<br/>            string_begins_with            = list(object({ key = string, values = list(string) }))<br/>            string_not_begins_with        = list(object({ key = string, values = list(string) }))<br/>            string_ends_with              = list(object({ key = string, values = list(string) }))<br/>            string_not_ends_with          = list(object({ key = string, values = list(string) }))<br/>            string_contains               = list(object({ key = string, values = list(string) }))<br/>            string_not_contains           = list(object({ key = string, values = list(string) }))<br/>            string_in                     = list(object({ key = string, values = list(string) }))<br/>            string_not_in                 = list(object({ key = string, values = list(string) }))<br/>            is_not_null                   = list(object({ key = string }))<br/>            is_null_or_undefined          = list(object({ key = string }))<br/>          }))<br/>        }))<br/>      }))<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the resource group will be created | `string` | `"westeurope"` | no |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | Private endpoints subnet id | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The Axso project name e.g. 'etools' | `string` | `"etools"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Azure resources. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The Axso environment subscription e.g. 'p' for production or 'np' for non-production | `string` | `"np"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network for the Azure resources. | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | Vnet resource group name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

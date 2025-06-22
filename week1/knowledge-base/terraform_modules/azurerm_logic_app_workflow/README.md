| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_logic_app_workflow?repoName=azurerm_logic_app_workflow&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2463&repoName=azurerm_logic_app_workflow&branchName=main) | **v1.3.5** | 24/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Logic App Configuration](#azure-logic-app-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Logic App Configuration

----------------------------

[Learn more about Azure Logic App in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure Logic App is a serverless, visual workflow automation service in Microsoft Azure that connects and automates processes between different applications and services. It enables the creation of automated workflows with minimal coding.

Currently the module does not support pulling configuration for workflow_parameters, workflow_schema or workflow_version we are using a lifecyle block in the backend module, meaning that the changes done in the portal in that settings will be ignored by terraform and the configuration will prevail if pipeline runs again.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_logic_app_workflow

## Pre-requisites
----------------------------

It is assumed that the following resources already exists:

- Resource Group


## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment` and `logic_app_description`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-logicapp-${var.logic_app_description}"`  
**NonProd:** `axso-np-appl-etools-dev-logicapp-clean`  
**Prod:** `axso-p-appl-etools-prod-logicapp-clean`  

# Terraform Files

----------------------------

## module.tf

```hcl

module "logicapp" {
  source                  = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_logic_app_workflow?ref=v1.3.5"
  for_each                = { for n in var.logic_app : n.logic_app_description => n }
  resource_group_name         = var.resource_group_name
  project_name                = var.project_name
  subscription                = var.subscription
  environment                 = var.environment
  location                    = var.location
  logic_app_description       = each.value.logic_app_description
  requires_identity           = each.value.requires_identity
  user_assigned_identity_name = var.user_assigned_identity_name
}

}

```

## module.tf.tfvars

```hcl
location                    = "West Europe"
environment                 = "dev"
project_name                = "ssp"
subscription                = "np"
user_assigned_identity_name = "axso-np-appl-ssp-test-umid"
resource_group_name         = "axso-np-appl-ssp-test-rg"

logic_app = [
  {
    logic_app_description = "chache-refresh"
    requires_identity     = false

  },
  {
    logic_app_description = "cache-clean"
    requires_identity     = true

  }
]

```

## variables.tf

```hcl
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

variable "user_assigned_identity_name" {
  type        = string
  description = "The name of your UMI"
}

variable "resource_group_name" {
  type        = string
  description = "The name of your RG"
}

variable "logic_app" {
  description = "Short description for the usage of the logicapp"
  type = list(object({
    logic_app_description = string
    requires_identity     = bool

  }))
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
| [azurerm_logic_app_workflow.logicapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_workflow) | resource |
| [azurerm_user_assigned_identity.identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location wherethe resources will be created | `string` | n/a | yes |
| <a name="input_logic_app_description"></a> [logic\_app\_description](#input\_logic\_app\_description) | The short description of the Logc App to create | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_requires_identity"></a> [requires\_identity](#input\_requires\_identity) | In case identity is needed please type 'true' or 'false' | `bool` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where your resources should reside | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | `"np"` | no |
| <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name) | The name of your UMI | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The Logic App ID |
<!-- END_TF_DOCS -->

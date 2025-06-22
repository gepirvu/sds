| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_log_analytics_workspace?repoName=azurerm_log_analytics_workspace&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2371&repoName=azurerm_log_analytics_workspace&branchName=main) | **v1.4.4** | 24/02/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Log Analytics Workspace Configuration](#azure-log-analytics-workspace-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Log Analytics Workspace Configuration

----------------------------

[Learn more about Azure Log Analytics Workspace Configuration in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

A Log Analytics workspace is a data store into which you can collect any type of log data from all of your Azure and non-Azure resources and applications. Workspace configuration options let you manage all of your log data in one workspace to meet the operations, analysis, and auditing needs of different personas in your organization

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_log_analytics_workspace

## Pre-requisites
----------------------------

It is assumed that the following resources already exists:

- Resource Group

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-loga"`  
**NonProd:** `axso-np-appl-etools-dev-loga`  
**Prod:** `axso-p-appl-etools-prod-loga`  

# Terraform Files

----------------------------

## module.tf

```hcl
module "log_analytics_workspace" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_log_analytics_workspace?ref=v1.4.4"
  location              = var.location
  resource_group_name   = var.resource_group_name
  project_name          = var.project_name
  subscription          = var.subscription
  environment           = var.environment
  retention_in_days_law = var.retention_in_days_law
}

```

## module.tf.tfvars

```hcl

location              = "West Europe"
environment           = "dev"
project_name          = "project"
subscription          = "np"
resource_group_name   = "axso-np-appl-ssp-test-rg"
retention_in_days_law = "30"

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

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds' "
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where your resources should reside"
}

variable "retention_in_days_law" {
  type        = number
  default     = 30
  description = "The Log Analytics Workspace data retention in days. Possible values range between 30 and 730."

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
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.1.0"
    }
  }
}

provider "azurerm" {
  features {
    app_configuration {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = false
    }
  }
  resource_provider_registrations = "none"
}

provider "azuread" {}

provider "random" {}
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
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the log analytics will be created | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where your resources should reside | `string` | n/a | yes |
| <a name="input_retention_in_days_law"></a> [retention\_in\_days\_law](#input\_retention\_in\_days\_law) | The Log Analytics Workspace data retention in days. Possible values range between 30 and 730. | `number` | `30` | no |
| <a name="input_sku_law"></a> [sku\_law](#input\_sku\_law) | Pricing tier of Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | `"np"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_laws_id"></a> [laws\_id](#output\_laws\_id) | value of the Log analytics workspace id |
| <a name="output_laws_name"></a> [laws\_name](#output\_laws\_name) | value of the Log analytics workspace name |
<!-- END_TF_DOCS -->

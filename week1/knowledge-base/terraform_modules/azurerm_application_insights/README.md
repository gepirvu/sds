| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_application_insights?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2456&branchName=main) | **v1.4.5** | 24/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Application Insights Configuration](#azure-application-insights-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Application Insights Configuration

----------------------------

[Learn more about Azure Application Insights Configuration in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure Monitor Application Insights, a feature of Azure Monitor, excels in application performance monitoring (APM) for live web applications.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_application_insights

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-insights"`  
**NonProd:** `axso-np-appl-etools-dev-insights`  
**Prod:** `axso-p-appl-etools-prod-insights`  

# Terraform Files

----------------------------

## Main

```hcl
module "appinsights" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_application_insights?ref=v1.4.5"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  application_type             = var.application_type
  subscription                 = var.subscription
  project_name                 = var.project_name
  environment                  = var.environment
  log_analytics_workspace_name = var.log_analytics_workspace_name
}
```

## module.tf.tfvars

```hcl

location                     = "West Europe"
environment                  = "dev"
project_name                 = "ssp"
application_type             = "web"
subscription                 = "np"
log_analytics_workspace_name = "axso-np-appl-cloudinfra-dev-loga"
resource_group_name          = "axso-np-appl-ssp-test-rg"


```

## variables.tf

```hcl

variable "location" {
  type        = string
  description = "Specifies azure region/location where resources will be created."
}
variable "resource_group_name" {
  type        = string
  description = "The name of the existing resource group to create the Application insights"
}

variable "environment" {
  type        = string
  description = "The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod'"
  default     = "dev"
}

variable "subscription" {
  type        = string
  description = "The short name of the subscription type e.g.  'p' or 'np'"
}

variable "project_name" {
  type        = string
  description = "The short name of the project e.g. 'mds'"
}


variable "application_type" {
  type        = string
  description = "The type of application insight you want to deploy"
}

variable "log_analytics_workspace_name" {
  type        = string
  default     = null
  description = "Log application workspace name to link between insights and log analytics workspace"
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
| [azurerm_application_insights.arm_app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_type"></a> [application\_type](#input\_application\_type) | The type of application insight you want to deploy | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies azure region/location where resources will be created. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Log application workspace name to link between insights and log analytics workspace | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the existing resource group to create the Application insights | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_insights_id"></a> [app\_insights\_id](#output\_app\_insights\_id) | value of the app insights id |
| <a name="output_connection_string"></a> [connection\_string](#output\_connection\_string) | value of the app insights connection string |
| <a name="output_instrumentation_key"></a> [instrumentation\_key](#output\_instrumentation\_key) | value of the app insights instrumentation key |
<!-- END_TF_DOCS -->

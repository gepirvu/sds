| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_monitor_workspace?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2960&branchName=main) | **v1.1.4**  | 24/02/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Monitor Workspace Configuration](#azure-monitor-workspace-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Monitor Workspace Configuration

----------------------------

[Learn more about Azure Monitor Workspace in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/azure-monitor-workspace-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

An Azure Monitor workspace is a unique environment for data collected by Azure Monitor. Each workspace has its own data repository, configuration, and permissions.
Log Analytics workspaces contain logs and metrics data from multiple Azure resources, whereas Azure Monitor workspaces currently contain only metrics related to Prometheus.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_monitor_workspace

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-${var.project_name}-${var.environment}-mws"`

**Example**: axso-np-ssp-dev-mws

# Terraform Files

----------------------------

## module.tf

```hcl

module "azurerm_monitor_workspace" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_monitor_workspace?ref=v1.1.4"  
  project_name        = var.project_name
  subscription        = var.subscription
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name
}

```

## module.tf.tfvars

```hcl

location     = "West Europe"
environment  = "dev"
project_name = "ssp"
subscription = "np"
resource_group_name = "axso-np-appl-ssp-test-rg"

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

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where Monitor Workspace will be deployed."
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
| [azurerm_monitor_workspace.monitor_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies azure region/location where resources will be created. | `string` | `"westeurope"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where Monitor Workspace will be deployed. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | `"np"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_monitor_workspace_id"></a> [monitor\_workspace\_id](#output\_monitor\_workspace\_id) | ID of the Monitor Workspace Resource |
<!-- END_TF_DOCS -->

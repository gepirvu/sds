| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_dashboard_grafana?repoName=azurerm_dashboard_grafana&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=3065&repoName=azurerm_dashboard_grafana&branchName=main) | **v1.3.1** | 24/03/2025 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Managed Grafana Configuration](#azure-managed-grafana-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Managed Grafana Configuration

----------------------------

[Learn more about Azure Managed Grafana in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/managed-grafana/overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure Managed Grafana is a data visualization platform built on top of the Grafana software by Grafana Labs. It's built as a fully managed Azure service operated and supported by Microsoft. Grafana helps you bring together metrics, logs and traces into a single user interface.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_monitor_workspace
- azurerm_dashboard_grafana
- azurerm_private_endpoint

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Private endpoint deployment
- Azure ad groups to assgin permission to the grafana instance

If you already have an Azure Monitor workspace, you can link it to Grafana. If not, an Azure Monitor workspace will be created in case you enable it.

## Axso Naming convention example

----------------------------

The below example will create an **Azure Managed Grafana** for the project **ssp** in the **nonprod** subscription in the **test** environment: `"axso4np4test4ssp4amg"`.

# Terraform Files

----------------------------


## module.tf

```hcl

module "axso_dashboard_grafana" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_dashboard_grafana?ref=v1.3.1"

  resource_group_name                             = var.resource_group_name
  location                                        = var.location
  project_name                                    = var.project_name
  subscription                                    = var.subscription
  environment                                     = var.environment
  network_resource_group_name                     = var.network_resource_group_name
  virtual_network_name                            = var.virtual_network_name
  monitor_workspace_public_network_access_enabled = var.monitor_workspace_public_network_access_enabled
  pe_subnet_name                                  = var.pe_subnet_name
  api_key_enabled                                 = var.api_key_enabled
  grafana_major_version                           = var.grafana_major_version
  sku                                             = var.sku
  zone_redundancy_enabled                         = var.zone_redundancy_enabled
  deterministic_outbound_ip_enabled               = var.deterministic_outbound_ip_enabled
  smtp_enable                                     = var.smtp_enable
  identity_type                                   = var.identity_type
  azure_monitor_workspace_enabled                 = var.azure_monitor_workspace_enabled
  admin_groups                                    = var.admin_groups
  editor_groups                                   = var.editor_groups
  viewer_groups                                   = var.viewer_groups

}

```

## module.tf.tfvars

```hcl

resource_group_name                             = "axso-np-appl-ssp-test-rg"
location                                        = "westeurope"
subscription                                    = "np"
project_name                                    = "cloudinfrastructure"
environment                                     = "test"
api_key_enabled                                 = false
grafana_major_version                           = "10"
sku                                             = "Standard"
zone_redundancy_enabled                         = false
deterministic_outbound_ip_enabled               = false
smtp_enable                                     = false
identity_type                                   = "SystemAssigned"
network_resource_group_name                     = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                            = "vnet-cloudinfra-nonprod-axso-e3og"
monitor_workspace_public_network_access_enabled = true
pe_subnet_name                                  = "pe"
azure_monitor_workspace_enabled                 = true
admin_groups                                    = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]
editor_groups                                   = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]
viewer_groups                                   = ["CL-AZ-SUBS-cloudinfra-nonprod-Owner"]

```

## variables.tf

```hcl

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

variable "resource_group_name" {
  type        = string
  default     = "axso-np-appl-<project-name>-<environment>-rg"
  description = "(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "west europe"
  description = "(Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created."
}

# Private endpoint (used in data block to get subnet ID)
variable "virtual_network_name" {
  type        = string
  description = "Virtual network name for the enviornment to enable private endpoint."
}

variable "pe_subnet_name" {
  type        = string
  description = "The subnet name, used in data source to get subnet ID, to enable the private endpoint."
}

variable "monitor_workspace_public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the public network access should be enabled for the Azure Monitor Workspace."

}

variable "network_resource_group_name" {
  type        = string
  description = "The existing core network resource group name, to get details of the VNET to enable  private endpoint."
}

variable "api_key_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the API key should be enabled for the Grafana instance."
}

variable "grafana_major_version" {
  type        = string
  default     = "10"
  description = "The major version of Grafana to use. Possible values are 9 and 10."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the Grafana instance. Possible values are Essential and Standard."

}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether zone redundancy should be enabled for the Grafana instance."
}

variable "deterministic_outbound_ip_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether the deterministic outbound IP should be enabled for the Grafana instance. Only use it in case you cant use private connection to the datasources."

}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "The identity type for the Grafana instance. Possible values are SystemAssigned and UserAssigned. UserAssigned is not supported yet."

}

variable "azure_monitor_workspace_enabled" {
  type        = bool
  default     = true
  description = "Indicates whether the Azure Monitor Workspace should be enabled for the Grafana instance."

}

variable "smtp_enable" {
  type        = bool
  default     = false
  description = "Indicates whether the SMTP should be enabled for the Grafana instance."

}

variable "admin_groups" {
  type        = list(string)
  default     = []
  description = "The list of admin groups for the Grafana instance."

}

variable "editor_groups" {
  type        = list(string)
  default     = []
  description = "The list of editor groups for the Grafana instance."

}

variable "viewer_groups" {
  type        = list(string)
  default     = []
  description = "The list of viewer groups for the Grafana instance."

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
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_dashboard_grafana.dashboard_grafana](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dashboard_grafana) | resource |
| [azurerm_monitor_workspace.monitor_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_workspace) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.private_endpoint_monitor_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.rbac_grafana_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_grafana_editor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_grafana_viewer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_grafana_data_reader_monitor_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_assignment_grafana_reader_monitor_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azuread_group.rbac_grafana_administrator](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.rbac_grafana_editor](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.rbac_grafana_viewer](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_monitor_workspace.monitor_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_workspace) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_groups"></a> [admin\_groups](#input\_admin\_groups) | The list of admin groups for the Grafana instance. | `list(string)` | `[]` | no |
| <a name="input_api_key_enabled"></a> [api\_key\_enabled](#input\_api\_key\_enabled) | Indicates whether the API key should be enabled for the Grafana instance. | `bool` | `false` | no |
| <a name="input_azure_monitor_workspace_enabled"></a> [azure\_monitor\_workspace\_enabled](#input\_azure\_monitor\_workspace\_enabled) | Indicates whether the Azure Monitor Workspace should be enabled for the Grafana instance. | `bool` | `true` | no |
| <a name="input_azure_monitor_workspace_name"></a> [azure\_monitor\_workspace\_name](#input\_azure\_monitor\_workspace\_name) | The name of the Azure Monitor Workspace. If null, the Azure Monitor Workspace will be created, if not null, the Azure Monitor Workspace specified will be used. | `string` | `null` | no |
| <a name="input_deterministic_outbound_ip_enabled"></a> [deterministic\_outbound\_ip\_enabled](#input\_deterministic\_outbound\_ip\_enabled) | Indicates whether the deterministic outbound IP should be enabled for the Grafana instance. Only use it in case you cant use private connection to the datasources. | `bool` | `false` | no |
| <a name="input_editor_groups"></a> [editor\_groups](#input\_editor\_groups) | The list of editor groups for the Grafana instance. | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_from_address"></a> [from\_address](#input\_from\_address) | The from email address for the Grafana instance. | `string` | `null` | no |
| <a name="input_from_name"></a> [from\_name](#input\_from\_name) | The from name for the Grafana instance. | `string` | `null` | no |
| <a name="input_grafana_major_version"></a> [grafana\_major\_version](#input\_grafana\_major\_version) | The major version of Grafana to use. Possible values are 9 and 10. | `string` | `"10"` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The identity type for the Grafana instance. Possible values are SystemAssigned and UserAssigned. UserAssigned is not supported yet. | `string` | `"SystemAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created. | `string` | `"west europe"` | no |
| <a name="input_monitor_workspace_public_network_access_enabled"></a> [monitor\_workspace\_public\_network\_access\_enabled](#input\_monitor\_workspace\_public\_network\_access\_enabled) | Indicates whether the public network access should be enabled for the Azure Monitor Workspace. | `bool` | `false` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The existing core network resource group name, to get details of the VNET to enable  private endpoint. | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The subnet name, used in data source to get subnet ID, to enable the private endpoint. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | `string` | `"axso-np-appl-<project-name>-<environment>-rg"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of the Grafana instance. Possible values are Essential and Standard. | `string` | `"Standard"` | no |
| <a name="input_smtp_enable"></a> [smtp\_enable](#input\_smtp\_enable) | Indicates whether the SMTP should be enabled for the Grafana instance. | `bool` | `false` | no |
| <a name="input_smtp_host"></a> [smtp\_host](#input\_smtp\_host) | The SMTP host for the Grafana instance. | `string` | `"smtp.example.com"` | no |
| <a name="input_smtp_password"></a> [smtp\_password](#input\_smtp\_password) | The SMTP password for the Grafana instance. | `string` | `"password"` | no |
| <a name="input_smtp_user"></a> [smtp\_user](#input\_smtp\_user) | The SMTP user for the Grafana instance. | `string` | `"user"` | no |
| <a name="input_start_tls_policy"></a> [start\_tls\_policy](#input\_start\_tls\_policy) | The start TLS policy for the Grafana instance. | `string` | `"OpportunisticStartTLS"` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |
| <a name="input_verification_skip_enabled"></a> [verification\_skip\_enabled](#input\_verification\_skip\_enabled) | Indicates whether the verification skip should be enabled for the Grafana instance. | `bool` | `false` | no |
| <a name="input_viewer_groups"></a> [viewer\_groups](#input\_viewer\_groups) | The list of viewer groups for the Grafana instance. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Virtual network name for the enviornment to enable private endpoint. | `string` | n/a | yes |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Indicates whether zone redundancy should be enabled for the Grafana instance. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_dashboard_grafana_id"></a> [azurerm\_dashboard\_grafana\_id](#output\_azurerm\_dashboard\_grafana\_id) | n/a |
| <a name="output_azurerm_dashboard_grafana_name"></a> [azurerm\_dashboard\_grafana\_name](#output\_azurerm\_dashboard\_grafana\_name) | n/a |
| <a name="output_azurerm_monitor_workspace_id"></a> [azurerm\_monitor\_workspace\_id](#output\_azurerm\_monitor\_workspace\_id) | n/a |
| <a name="output_azurerm_monitor_workspace_name"></a> [azurerm\_monitor\_workspace\_name](#output\_azurerm\_monitor\_workspace\_name) | n/a |
<!-- END_TF_DOCS -->

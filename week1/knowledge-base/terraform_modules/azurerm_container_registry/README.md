| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_container_registry?repoName=azurerm_container_registry&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2468&repoName=azurerm_container_registry&branchName=main) | **v1.4.4** | 25/03/2025 |

# INDEX

----------------------------

1. [Azure Container Registry Configuration](#azure-container-registry-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Container Registry Configuration

----------------------------

[Learn more about Azure Container Registry in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure Container Registry is a managed registry service based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your container images and related artifacts.

Use container registries with your existing container development and deployment pipelines, or use Azure Container Registry tasks to build container images in Azure. Build on demand, or fully automate builds with triggers such as source code commits and base image updates.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_container_registry
- azurerm_private_endpoint

## Pre-requisites
----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Private endpoint deployment

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment`:  

**Construct:** `"axso4${var.subscription}4${var.project_name}4${var.environment}4acr"`  
**NonProd:** `axso4np4cloudinfra4dev4acr`  
**Prod:** `axso4p4cloudinfra4prod4acr`  

# Terraform Files

----------------------------

## module.tf

```hcl

module "axso_container_registry" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_container_registry?ref=v1.4.4"

  resource_group_name = var.resource_group_name
  location            = var.location

  project_name             = var.project_name
  subscription             = var.subscription
  environment              = var.environment
  admin_enabled            = var.admin_enabled
  retention_policy_in_days = var.retention_policy_in_days
  data_endpoint_enabled    = var.data_endpoint_enabled
  # Identity
  identity_type = var.identity_type
  acr_umids     = var.acr_umids

  # Networking
  pe_subnet                     = var.pe_subnet
  allowed_ip_ranges             = var.allowed_ip_ranges
  acr_allowed_subnets           = var.acr_allowed_subnets
  public_network_access_enabled = var.public_network_access_enabled

  # Georeplication
  georeplications_configuration = var.georeplications_configuration

}
```

## module.tf.tfvars

```hcl

#===========================================================================================================================================#
# General                                                                                                                                   #
#===========================================================================================================================================#

project_name = "cloudinfra"

subscription = "np"

environment = "test"

resource_group_name = "axso-np-appl-ssp-test-rg"

location = "westeurope"

#===========================================================================================================================================#
# Container registry                                                                                                                        #
#===========================================================================================================================================#
admin_enabled = false

retention_policy_in_days = 7

data_endpoint_enabled = true

identity_type = "SystemAssigned, UserAssigned" # "SystemAssigned"  "SystemAssigned" or "UserAssigned" or "SystemAssigned, UserAssigned"

acr_umids = [
  {
    umid_name    = "axso-np-appl-ssp-test-umid"
    umid_rg_name = "axso-np-appl-ssp-test-rg"
  }
]

pe_subnet = {
  subnet_name  = "pe"
  vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
  vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
}

acr_allowed_subnets = {
  "subnet-1" = {
    subnet_name  = "compute"
    vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
    vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
  },
  "subnet-2" = {
    subnet_name  = "aks"
    vnet_name    = "vnet-cloudinfra-nonprod-axso-e3og"
    vnet_rg_name = "rg-cloudinfra-nonprod-axso-ymiw"
  }
}

georeplications_configuration = [
  {
    location                = "North Europe" # The georeplications list cannot contain the location where the Container Registry exists.
    zone_redundancy_enabled = false
  }

  # If more than one georeplications block is specified, they are expected to follow the alphabetic order on the location property.
]

#===========================================================================================================================================#

```

## variables.tf

```hcl
#===========================================================================================================================================#
# General                                                                                                                                   #
#===========================================================================================================================================#

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
  default     = "prod"
  description = "The environment. e.g. dev, qa, uat, prod"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

#===========================================================================================================================================#
# Container registry                                                                                                                        #
#===========================================================================================================================================#

variable "retention_policy_in_days" {
  type        = number
  default     = 7
  description = "(Optional) This policy checks if the retention policy is enabled for Azure Container Registry, ensuring that untagged manifests are automatically deleted.. Defaults to 7 days."

}

variable "data_endpoint_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Dedicated data endpoints enhance security by directing data connections through private IPs within your virtual network. Disabled endpoints expose data to the public internet, increasing the risk of interception or breaches. Enabling dedicated data endpoints strengthens your security posture. Defaults to true."

}

variable "identity_type" {
  type        = string
  default     = "UserAssigned"
  description = "The type of Managed Service Identity that should be configured on this App Configuration."
}

variable "acr_umids" {
  type = list(object({
    umid_name    = string
    umid_rg_name = string
  }))
}

variable "pe_subnet" {
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether or not public network access is allowed for the container registry. Defaults to false."
}

variable "allowed_ip_ranges" {
  type        = list(string)
  default     = ["159.168.125.252/30", "159.168.7.144/29", "159.168.126.252/30"]
  description = "List of IP addresses that are allowed to access the container registry. The IP address ranges in CIDR notation. e.g."
}

variable "acr_allowed_subnets" {
  type = map(object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  }))
}

variable "admin_enabled" {
  type        = bool
  default     = false
  description = "The admin enabled setting for the Azure Container Registry."
}

variable "georeplications_configuration" {
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
  }))
  default     = []
  description = "ACR must be on SKU 'Premium' to enable Geo-replication. Location must be different to primary location of ACR."
}

#===========================================================================================================================================#
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

provider "azuread" {}
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
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_subnet.acr_allowed_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_allowed_subnets"></a> [acr\_allowed\_subnets](#input\_acr\_allowed\_subnets) | n/a | <pre>map(object({<br/>    subnet_name  = string<br/>    vnet_name    = string<br/>    vnet_rg_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_acr_network_rule_set_default_action"></a> [acr\_network\_rule\_set\_default\_action](#input\_acr\_network\_rule\_set\_default\_action) | n/a | `string` | `"Deny"` | no |
| <a name="input_acr_umids"></a> [acr\_umids](#input\_acr\_umids) | n/a | <pre>list(object({<br/>    umid_name    = string<br/>    umid_rg_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | (Optional) Specifies whether the admin user is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_allowed_ip_ranges"></a> [allowed\_ip\_ranges](#input\_allowed\_ip\_ranges) | List of IP addresses that are allowed to access the container registry. The IP address ranges in CIDR notation. e.g. | `list(string)` | <pre>[<br/>  "159.168.125.252/30",<br/>  "159.168.7.144/29",<br/>  "159.168.126.252/30"<br/>]</pre> | no |
| <a name="input_data_endpoint_enabled"></a> [data\_endpoint\_enabled](#input\_data\_endpoint\_enabled) | (Optional) Dedicated data endpoints enhance security by directing data connections through private IPs within your virtual network. Disabled endpoints expose data to the public internet, increasing the risk of interception or breaches. Enabling dedicated data endpoints strengthens your security posture. Defaults to true. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod"` | no |
| <a name="input_georeplications_configuration"></a> [georeplications\_configuration](#input\_georeplications\_configuration) | n/a | <pre>list(object({<br/>    location                = string<br/>    zone_redundancy_enabled = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Required) Specifies the type of Managed Service Identity that should be configured on this App Configuration. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). | `string` | `"SystemAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"westeurope"` | no |
| <a name="input_pe_subnet"></a> [pe\_subnet](#input\_pe\_subnet) | n/a | <pre>object({<br/>    subnet_name  = string<br/>    vnet_name    = string<br/>    vnet_rg_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Specifies whether or not public network access is allowed for the container registry. Defaults to false. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_retention_policy_in_days"></a> [retention\_policy\_in\_days](#input\_retention\_policy\_in\_days) | (Optional) This policy checks if the retention policy is enabled for Azure Container Registry, ensuring that untagged manifests are automatically deleted.. Defaults to 7 days. | `number` | `7` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | This will output id of Azure Container Registry |
<!-- END_TF_DOCS -->

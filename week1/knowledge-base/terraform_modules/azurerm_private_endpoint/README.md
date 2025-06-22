| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_private_endpoint?repoName=azurerm_private_endpoint&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2334&repoName=azurerm_private_endpoint&branchName=main) | **v2.0.5** | **25/03/2025** |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Azure Private Endpoint Configuration](#azure-private-endpoint-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Private Endpoint Configuration

----------------------------

[Learn more about Azure Private Endpoint in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

A private endpoint is a network interface that uses a private IP address from your virtual network. This network interface connects you privately and securely to a service that's powered by Azure Private Link. By enabling a private endpoint, you're bringing the service into your virtual network.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_private_endpoint

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Private endpoint deployment
- Resource to be Private Endpointed (E.g. Key Vault, Storage Account, etc.)

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` , `environment`:  

### Storage Account Example

**Construct:** `"${name_of_resource}-pe"`  
**NonProd:** `axso4np4dev4etools4xyz-pe`  
**Prod:** `axso4p4dev4etools4xyz-pe`

**Construct:** `"${name_of_resource}-pe-sc"`  
**NonProd:** `axso4np4dev4etools4xyz-pe-sc`  
**Prod:** `axso4p4dev4etools4xyz-pe-sc`

# Terraform Files

----------------------------

## module.tf

```hcl

module "private_endpoint_kv" {
  source                              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_endpoint?ref=v2.0.5"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_name                = var.virtual_network_name
  pe_subnet_name                      = var.pe_subnet_name
  private_endpoint_name               = var.private_endpoint_name
  private_connection_resource_id      = var.private_connection_resource_id
  private_dns_zone_group              = var.private_dns_zone_group
  is_manual_connection                = var.is_manual_connection
  subresource_names                   = var.subresource_names
}

```

## module.tf.tfvars

```hcl


#common variables
private_dns_zone_name               = "privatelink.vaultcore.azure.net"
private_endpoint_name               = "kv-ssp-0-nonprod-axso-pe-2"
resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name                = "vnet-cloudinfra-nonprod-axso-e3og"
pe_subnet_name                      = "pe"
private_dns_zone_group = [
  {
    enabled              = true
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = ["/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }
]
subresource_names              = ["Vault"]
is_manual_connection           = false
private_connection_resource_id = "/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.KeyVault/vaults/kv-ssp-0-nonprod-axso"

```

## variables.tf

```hcl

#Common vars
variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the private endpoint resource will be created."
  nullable    = false
}


variable "private_endpoint_name" {
  type        = string
  description = "The name of the Private Endpoint."
}

variable "private_connection_resource_id" {
  type        = string
  description = "The Resource ID which the private endpoint should be created for."
}

variable "private_dns_zone_group" {
  type = list(object({
    enabled              = bool
    name                 = string
    private_dns_zone_ids = list(string)
  }))
  default     = []
  description = "List of private dns zone groups to associate with the private endpoint."
}

variable "is_manual_connection" {
  type        = bool
  description = "Boolean flag to specify whether the connection should be manual."
  default     = false
}

variable "subresource_names" {
  type        = list(string)
  description = "A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id. Changing this forces a new resource to be created."
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the vnet is located"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet where the private endpoint will be created"
}

variable "pe_subnet_name" {
  type        = string
  description = "The name of the subnet where the private endpoint will be created"
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
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subnet.pe_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_is_manual_connection"></a> [is\_manual\_connection](#input\_is\_manual\_connection) | Boolean flag to specify whether the connection should be manual. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | `"westeurope"` | no |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The name of the subnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_private_connection_resource_id"></a> [private\_connection\_resource\_id](#input\_private\_connection\_resource\_id) | The Resource ID which the private endpoint should be created for. | `string` | n/a | yes |
| <a name="input_private_dns_zone_group"></a> [private\_dns\_zone\_group](#input\_private\_dns\_zone\_group) | List of private dns zone groups to associate with the private endpoint. | <pre>list(object({<br/>    enabled              = bool<br/>    name                 = string<br/>    private_dns_zone_ids = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_private_endpoint_name"></a> [private\_endpoint\_name](#input\_private\_endpoint\_name) | The name of the Private Endpoint. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the private endpoint resource will be created. | `string` | n/a | yes |
| <a name="input_subresource_names"></a> [subresource\_names](#input\_subresource\_names) | A list of subresource names which the Private Endpoint is able to connect to. subresource\_names corresponds to group\_id. Changing this forces a new resource to be created. | `list(string)` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the vnet where the private endpoint will be created | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group where the vnet is located | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID value of the private endpoint. |
| <a name="output_name"></a> [name](#output\_name) | The name of the private endpoint. |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | value of the private ip address of the private endpoint. |
<!-- END_TF_DOCS -->

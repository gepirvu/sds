| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_network_security_rule?repoName=azurerm_network_security_rule&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2461&repoName=azurerm_network_security_rule&branchName=main) | **v1.2.5** | 25/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX
-------

1. [Azure Network security rule](#azure-network-security-rule)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Azure Network security rule
-----------------------------

[Learn more about Azure Network security rule in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview#security-rules)

## Service Description
----------------------

You can use an Azure network security group to filter network traffic between Azure resources in an Azure virtual network. A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources. For each rule, you can specify source and destination, port, and protocol.

This article describes the properties of a network security group rule, the default security rules that are applied, and the rule properties that you can modify to create an augmented security rule.

## Deployed Resources
---------------------

This module will deploy the following azurerm resources:

- azurerm_network_security_rule(s)

## Pre-requisites
-----------------

It is assumed that the following resources already exists:

- Resource Group
- Network security group

## Axso Naming convention example
---------------------------------

The naming convention can be used as per project needs as it is not an resource, it will be created withing NSG. 

# Terraform Files
-----------------

## module.tf

```hcl
module "axso_nsg_rules" {
  for_each            = toset(var.network_security_groups)
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_network_security_rule?ref=v1.2.5"
  resource_group_name = var.resource_group_name
  nsg_name            = each.key
  nsg_rules           = lookup(local.nsg_config[each.key], "nsgRules", null)
}
```

## module.tf.tfvars

```hcl
location = "westeurope"

resource_group_name = "axso-np-appl-ssp-test-rg"

network_security_groups = [
  "axso-np-appl-test-nsg-1",
  "axso-np-appl-test-nsg-2"
]
```

## variables.tf

```hcl
variable "location" {
  description = "The location/region where the resource group will be created."
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Specifies the Resource Group that contains Network Security Groups(NSGs) to be configured/administered"
  default     = "rg-where-nsgs-are-located"
  nullable    = false
}

variable "network_security_groups" {
  type        = list(string)
  description = "List of network security groups to apply rules to."
}
```

## locals.tf

```hcl
#Master config file
locals {
  nsg_config = {
    #Identify NSG 1 
    axso-np-appl-test-nsg-1 = {
      nsgRules = [
        {
          nsg_rule_name              = "DummyRule-Deny-Access-from"
          priority                   = "100"
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "192.168.10.0/24"
          destination_address_prefix = "VirtualNetwork"
        },
        {
          nsg_rule_name              = "DummyRule-Deny-Access-to"
          priority                   = "100"
          direction                  = "Outbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "192.168.10.0/24"
        }
      ]
    }

    #Identify NSG 2 
    axso-np-appl-test-nsg-2 = {
      nsgRules = [
        {
          nsg_rule_name              = "DummyRule-Deny-Access-from"
          priority                   = "100"
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "192.168.20.0/24"
          destination_address_prefix = "VirtualNetwork"
        },
        {
          nsg_rule_name              = "DummyRule-Deny-Access-to"
          priority                   = "100"
          direction                  = "Outbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "192.168.20.0/24"
        }
      ]
    }
  }
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
| [azurerm_network_security_rule.network_nsg_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name) | Specifies the Network Security Group(NSG) name | `string` | n/a | yes |
| <a name="input_nsg_rules"></a> [nsg\_rules](#input\_nsg\_rules) | Specifies a list of objects to represent Network Security Group(NSG) rules | <pre>list(object({<br/>    nsg_rule_name                = optional(string, "default_rule_name")<br/>    priority                     = optional(string, "101")<br/>    direction                    = optional(string, "Any")<br/>    access                       = optional(string, "Allow")<br/>    protocol                     = optional(string, "*")<br/>    source_port_range            = optional(string, null)<br/>    source_port_ranges           = optional(list(string), null)<br/>    destination_port_range       = optional(string, null)<br/>    destination_port_ranges      = optional(list(string), null)<br/>    source_address_prefix        = optional(string, null)<br/>    source_address_prefixes      = optional(list(string), null)<br/>    destination_address_prefix   = optional(string, null)<br/>    destination_address_prefixes = optional(list(string), null)<br/>  }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the Resource Group that contains Network Security Groups(NSGs) to be configured/administered | `string` | `"rg-where-nsgs-are-located"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_rules_map"></a> [nsg\_rules\_map](#output\_nsg\_rules\_map) | Output map of NSG rules created |
<!-- END_TF_DOCS -->

| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
[![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_private_dns_records?repoName=azurerm_private_dns_records&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2341&repoName=azurerm_private_dns_records&branchName=main) | **v1.3.0** | 13/11/2024 |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Private DNS Records configuration](#private-dns-records-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Private DNS Records Configuration

----------------------------

[Learn more about Private DNS Records](https://learn.microsoft.com/en-us/azure/dns/dns-private-records)

## Service Description

----------------------------

A Private DNS record in Azure is a DNS entry created within an Azure Private DNS Zone, allowing for domain name resolution within a virtual network without exposing the domain publicly on the internet. 

## Deployed Resources

----------------------------

This module allows the following private DNS records to be deployed:

- azurerm_private_dns_a_record
- azurerm_private_dns_aaaa_record
- azurerm_private_dns_cname_record
- azurerm_private_dns_mx_record
- azurerm_private_dns_ptr_record
- azurerm_private_dns_srv_record
- azurerm_private_dns_txt_record


## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Private DNS Zone - :information_source: **In most cases under new management group, it will already be created and will reside under Group IT Subscriptions**


## Axso Naming convention example

----------------------------

The name of the DNS record is determined by your DNS . (Private DNS Record Name)+$(Private DNS Zone name)


## Terraform Files

----------------------------

>
>**Note**:
>Not all record types are required to be specified in the usage of this module, this example shows all types.  
>Use only the record types that you require.
>

## module.tf

```hcl

# A Records

module "dns-a-records-administration" {
  providers = {
    azurerm = azurerm.dns
  }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=v1.3.0"
  private_dns_zone_name    = "example.zone.local"
  resource_group_name      = "rg-where-private-dns-zone-is-located"
  private_dns_record_type  = "A"
  private_dns_record_ttl   = 300
  private_dns_record_name  = "TestARecord"
  private_dns_record_value = ["10.0.1.10"]
}

# AAAA Records

module "dns-aaaa-records-administration" {
  providers = {
    azurerm = azurerm.dns
  }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=v1.3.0"
  private_dns_zone_name    = "example.zone.local"
  resource_group_name      = "rg-where-private-dns-zone-is-located"
  private_dns_record_type  = "AAAA"
  private_dns_record_ttl   = 300
  private_dns_record_name  = "TestAAAARecord"
  private_dns_record_value = ["fd00:0:0:1::1"]
}

# PTR Records

module "dns-ptr-records-administration" {
  providers = {
    azurerm = azurerm.dns
  }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=v1.3.0"
  private_dns_zone_name    = "example.zone.local"
  resource_group_name      = "rg-where-private-dns-zone-is-located"
  private_dns_record_type  = "PTR"
  private_dns_record_ttl   = 300
  private_dns_record_name  = "16"
  private_dns_record_value = ["test2.example.com"]
}

# CNAME Records

module "dns-cname-records-administration" {
  providers = {
    azurerm = azurerm.dns
  }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=v1.3.0"
  private_dns_zone_name    = "example.zone.local"
  resource_group_name      = "rg-where-private-dns-zone-is-located"
  private_dns_record_type  = "CNAME"
  private_dns_record_ttl   = 300
  private_dns_record_name  = "msservice1"
  private_dns_record_value = "contoso.com"
}

# MX Records

module "dns-mx-records-administration" {
  providers = {
    azurerm = azurerm.dns
  }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=v1.3.0"
  private_dns_zone_name    = "example.zone.local"
  resource_group_name      = "rg-where-private-dns-zone-is-located"
  private_dns_record_type  = "MX"
  private_dns_record_ttl   = 300
  private_dns_record_name  = "mail1"
  private_dns_record_value = [
      { preference = 10, exchange = "mx1.contoso.com" },
      { preference = 20, exchange = "backupmx.contoso.com" }
    ]
}

# SRV Records

module "dns-srv-records-administration" {
  providers = {
    azurerm = azurerm.dns
  }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=v1.3.0"
  private_dns_zone_name    = "example.zone.local"
  resource_group_name      = "rg-where-private-dns-zone-is-located"
  private_dns_record_type  = "SRV"
  private_dns_record_ttl   = 300
  private_dns_record_name  = "_sip._tcp"
  private_dns_record_value = [
      {
        priority = 1
        weight   = 5
        port     = 5060
        target   = "sipserver1.contoso.com"
      },
      {
        priority = 10
        weight   = 10
        port     = 5060
        target   = "sipserver2.contoso.com"
      }
    ]
}

# TXT Records

module "dns-txt-records-administration" {
  providers = {
    azurerm = azurerm.dns
  }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=v1.3.0"
  private_dns_zone_name    = "example.zone.local"
  resource_group_name      = "rg-where-private-dns-zone-is-located"
  private_dns_record_type  = "TXT"
  private_dns_record_ttl   = 300
  private_dns_record_name  = "wwww"
  private_dns_record_value = {
      value = "v=spf1 a mx ptr include:contoso.com ~all"
    }
}

```

## main.tf

```
terraform {
  backend "azurerm" {}
 
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.8.0"
    }       
  }
}
 
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "azurerm" {
  alias           = "dns"
  subscription_id = "36cae50e-ce2a-438f-bd97-216b7f682c77" # Change if target Private DNS Zone is not in Group IT Subscription
  features {}
}
``` 


----------------------------

# Input Description

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53 |
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
| [azurerm_private_dns_a_record.private_dns_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_aaaa_record.private_dns_aaaa_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_aaaa_record) | resource |
| [azurerm_private_dns_cname_record.private_dns_cname_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_cname_record) | resource |
| [azurerm_private_dns_mx_record.private_dns_mx_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_mx_record) | resource |
| [azurerm_private_dns_ptr_record.private_dns_ptr_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_ptr_record) | resource |
| [azurerm_private_dns_srv_record.private_dns_srv_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_srv_record) | resource |
| [azurerm_private_dns_txt_record.private_dns_txt_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_txt_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_dns_record_name"></a> [private\_dns\_record\_name](#input\_private\_dns\_record\_name) | value of the private dns record name | `string` | `"testrecord"` | no |
| <a name="input_private_dns_record_ttl"></a> [private\_dns\_record\_ttl](#input\_private\_dns\_record\_ttl) | value of the private dns record ttl | `number` | `300` | no |
| <a name="input_private_dns_record_type"></a> [private\_dns\_record\_type](#input\_private\_dns\_record\_type) | value of the private dns record type, only allowed options are: 'A', 'AAAA', 'CNAME', 'MX', 'PTR', 'SRV', 'TXT' | `string` | `"A"` | no |
| <a name="input_private_dns_record_value"></a> [private\_dns\_record\_value](#input\_private\_dns\_record\_value) | value of the private dns record/s block. Usage of any is due to the fact that each record type has a different structure which can be string:[CNAME], set:[A, AAAA, PTR] or object:[MX, SRV, TXT] | `any` | n/a | yes |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | value of the private dns zone name | `string` | `"myorg.zone.local"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | value of the resource group name | `string` | `"rg-where-private-dns-zone-is-located"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_a_record_fqdns"></a> [dns\_a\_record\_fqdns](#output\_dns\_a\_record\_fqdns) | The FQDNs of the A records. |
| <a name="output_dns_a_record_ids"></a> [dns\_a\_record\_ids](#output\_dns\_a\_record\_ids) | The FQDNs of the A records. |
<!-- END_TF_DOCS -->
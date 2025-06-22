| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_rbac_administration?repoName=azurerm_rbac_administration&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2378&repoName=azurerm_rbac_administration&branchName=main) | **v1.0.17** | **25/03/2025** |

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Resource Configuration](#resource-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# [RBAC Administration Configuration](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal/?wt.mc_id=DT-MVP-5004771)

----------------------------

## Service Description

----------------------------

Azure Role Assignment grants users, groups, or applications access to Azure resources. It involves associating a security principal (user, group, or application) with a specific role definition and a scope (a resource group, subscription, or resource). This determines what actions the security principal can perform on the specified resources.

This module will:

- Grant a specific role over a scope to a Service Principal, Managed Identity, User or Group.

## Pre-requisites

----------------

- User, Group, Service Principal or Managed Identity.

> **:warning: Use object ID only**

- Target resource ID.

# Terraform Files

----------------------------

## module.tf

```hcl
module "role-assignment" {
  source            = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_rbac_administration?ref=v1.0.17" 
  azure_rbac_config = local.azure_rbac_config
}
```

## locals.tf
  
```hcl
locals {
  azure_rbac_config = [
    {
      description          = "Example - Azure RBAC permission on existing Resource Group"
      scope                = "/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.KeyVault/vaults/kv-ssp-0-nonprod-axso"    #Retrieve the ID of the resource to apply permissions to (e.g. Resource Group, Key Vault, Storage Account, etc.)
      role_definition_name = "Contributor"    # The name of the role definition to assign to the principal (e.g.Contributor, Reader, etc.)
      principal_id         = "b113fx90-da78-49b8-8830-e3a8bffbe650"   #The ID of the principal to assign to the role definition (e.g. Azure AD Group, Service Principal, User etc.)
    },
    {
      description          = "Example - Azure RBAC permission on existing KeyVault"
      scope                = "/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.KeyVault/vaults/kv-ssp-0-nonprod-axso"    #Retrieve the ID of the resource to apply permissions to (e.g. Resource Group, Key Vault, Storage Account, etc.)
      role_definition_name = "Owner"    # The name of the role definition to assign to the principal (e.g.Contributor, Reader, etc.)
      principal_id         = "b113fx90-da78-49b8-8830-e3a8bffbe650"   #The ID of the principal to assign to the role definition (e.g. Azure AD Group, Service Principal, User etc.)
    }
  ]
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
| [azurerm_role_assignment.rbac](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_rbac_config"></a> [azure\_rbac\_config](#input\_azure\_rbac\_config) | Azure RBAC role assignment (permissions) configuration. | <pre>list(object({<br/>    description          = string<br/>    scope                = string<br/>    role_definition_name = string<br/>    principal_id         = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "description": "Example - Azure RBAC permision on Subscription",<br/>    "principal_id": "00000000-0000-0000-0000-000000000000",<br/>    "role_definition_name": "Contributor",<br/>    "scope": "/subscriptions/00000000-0000-0000-0000-000000000000"<br/>  },<br/>  {<br/>    "description": "Example - Azure RBAC permision on Resource Group",<br/>    "principal_id": "00000000-0000-0000-0000-000000000000",<br/>    "role_definition_name": "Contributor",<br/>    "scope": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup"<br/>  },<br/>  {<br/>    "description": "Example - Azure RBAC permision on Resource",<br/>    "principal_id": "00000000-0000-0000-0000-000000000000",<br/>    "role_definition_name": "Contributor",<br/>    "scope": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM"<br/>  },<br/>  {<br/>    "description": "Example - Azure RBAC permision on Management Group",<br/>    "principal_id": "00000000-0000-0000-0000-000000000000",<br/>    "role_definition_name": "Contributor",<br/>    "scope": "/providers/Microsoft.Management/managementGroups/myMG"<br/>  }<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_assignment_ids"></a> [role\_assignment\_ids](#output\_role\_assignment\_ids) | The Role Assignment IDs. |
<!-- END_TF_DOCS -->

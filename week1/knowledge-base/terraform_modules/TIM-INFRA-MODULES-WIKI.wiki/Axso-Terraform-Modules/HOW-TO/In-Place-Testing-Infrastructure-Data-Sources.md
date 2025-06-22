# In Place Testing Infrastructure Data Sources

## Introduction

As part of module development, it is important to test the module in isolation. This is to ensure that the module is working as expected. In certain scenarios, the module may require **data** from **other or existing** resources to be able to function. For example, a module that creates a storage account may require a resource group to be created first. In this case, the module will need to be tested in the context of a resource group.  

Instead of creating supporting resources for testing, the Platform team has some pre-built resources to test against. These resources are located in the **[sub-cloudinfra-nonprod-axso](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/overview)** subscription in Azure. (ID: `77116f35-6e77-4f5f-b82f-49e50812cc75`)  

The following resources are available for testing against:

- **Resource Group:** axso-np-appl-ssp-test-rg ([link](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/overview))
- **Storage Account:** axso4p4ssp4np4testsa ([link](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.Storage/storageAccounts/axso4p4ssp4np4testsa/overview))
- **Key Vault:** kv-ssp-0-nonprod-axso ([link](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.KeyVault/vaults/kv-ssp-0-nonprod-axso/overview))
- **Virtual Network:** vnet-ssp-nonprod-axso-vnet ([link](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.Network/virtualNetworks/vnet-ssp-nonprod-axso-vnet/overview))
- **Route Table:** axso-np-appl-ssp-test-rt ([link](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.Network/routeTables/axso-np-appl-ssp-test-rt/overview))
- **User Assigned Managed Identity:** axso-np-appl-ssp-test-umid ([link](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/axso-np-appl-ssp-test-umid/overview))
- **Log Analytics Workspace:** axso-np-appl-cloudinfra-dev-loga ([link](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/Microsoft.OperationalInsights/workspaces/axso-np-appl-cloudinfra-dev-loga/Overview))
- **Azure Monitor Workspace:** axso-p-appl-aphub-prod-mws ([link](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/77116f35-6e77-4f5f-b82f-49e50812cc75/resourceGroups/axso-np-appl-ssp-test-rg/providers/microsoft.monitor/accounts/axso-np-appl-prj-dev-mws/resourceOverviewId))

## Data Sources for Testing

### Resource Group

```hcl
data "azurerm_resource_group" "resource_group" {
  name = "axso-np-appl-ssp-test-rg"
}
```

## Storage Account

```hcl
data "azurerm_storage_account" "storage_account" {
  name                = "axso4p4ssp4np4testsa"
  resource_group_name = "axso-np-appl-ssp-test-rg"
}
```

## Key Vault

```hcl
data "azurerm_key_vault" "key_vault" {
  name                = "kv-ssp-0-nonprod-axso"
  resource_group_name = "axso-np-appl-ssp-test-rg"
}
```

## Virtual Network

```hcl
data "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-ssp-nonprod-axso-vnet"
  resource_group_name = "axso-np-appl-ssp-test-rg"
}
```

## Route Table

```hcl
data "azurerm_route_table" "route_table" {
  name                = "axso-np-appl-ssp-test-rt"
  resource_group_name = "axso-np-appl-ssp-test-rg"
}
```

## User Assigned Managed Identity

```hcl
data "azurerm_user_assigned_identity" "example" {
  name                = "axso-np-appl-ssp-test-umid"
  resource_group_name = "axso-np-appl-ssp-test-rg"
}
```

## Log Analytics Workspace

```hcl
data "azurerm_log_analytics_workspace" "example" {
  name                = "axso-np-appl-cloudinfra-dev-loga"
  resource_group_name = "axso-np-appl-ssp-test-rg"
}
```

## Azure Monitor Workspace

```hcl
data "azurerm_monitor_workspace" "monitor_workspace" {
  name                = "axso-np-appl-prj-dev-mws"
  resource_group_name = "axso-np-appl-ssp-test-rg"
}
```

## Private DNS testing

Private DNS zones are created and managed outside of the control of the Platform team and thus testing modules that require **Private Endpoints** will need additional configuration by using **terraform aliasing**.  

Private DNS zones are created and managed by the Group IT team in subscription: **[sub-connectivity-prod-axpogroup](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/overview)**. (ID: `36cae50e-ce2a-438f-bd97-216b7f682c77`)  
Check the following Resource Group for a list of Private DNS zones that are available and managed by Group IT: **[rg-privatedns-pe-prod-axpo](https://portal.azure.com/#@axpogrp.onmicrosoft.com/resource/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/overview)**

The following is an example of how to use terraform aliasing to test a module that requires a private endpoint using Group IT managed Private DNS:

```hcl
# First create a provider alias for the Group IT subscription
provider "azurerm" {
  alias           = "group_it_private_dns"
  subscription_id = "36cae50e-ce2a-438f-bd97-216b7f682c77"
  features {}
}

# Then create a data source for the Private DNS zone (Example Key vault)
data "azurerm_private_dns_zone" "test_kv_pe" {
  provider            = azurerm.group_it_private_dns
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "rg-privatedns-pe-prod-axpo"
}
```

## Platform Team DevOps Pipeline and Service Connection

The platform team DevOps Service Connection: **"cl-axso-az-core-cloudinfra-nonprod-spi"** is used to access the testing subscription and resources for testing.  

```yml
trigger:
  none

resources:
  repositories:
    - repository: Terraform_Deployment_Pipeline
      type: git
      name: TIM-INFRA-MODULES/terraform_yaml_pipeline_templates
      ref: refs/heads/main

variables:
- template: testing-feature-vars.yml

stages:
  - template: tf_main.yml@Terraform_Deployment_Pipeline
    parameters:
          environment_name: "${{ variables.environment }}"
          tfvarFile: "module.tf.tfvars"
          root_directory: "/Tests/"
          service_connection_name: "cl-axso-az-core-cloudinfra-nonprod-spi" ##access to the testing subscription
          backend_resource_group: "axso-prod-appl-tim-infra-modules-rg" ##resource group for the backend storage account
          backend_storage_accountname: "axso4prod4appl4tim4sa" ##storage account name for the backend that stores state
          container_name: "terraform-tim-infra-modules" ##container name for the backend that stores state
          container_key: "$(Build.Repository.Name)/test_${{ variables.environment }}.tfstate" ##state file
          pool: "${{ variables.agentPool }}"
          terraformVersion: "${{ variables.terraformVersion }}"
          environment_name_Job: "TF_${{ variables.environment }}_TEST_${{ variables.repo }}"
```

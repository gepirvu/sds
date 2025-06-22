| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_api_management?branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=3359&branchName=main) | **v1.4.3** | 25/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [API Management Configuration](#api-management-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# API Management Configuration

----------------------------

[Learn more about API Management](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts/?wt.mc_id=DT-MVP-5004771)

## Service Description

----------------------------

Azure API Management (APIm) is a fully managed service that enables organizations to create, publish, secure, monitor, and analyze APIs in a scalable and reliable environment. It acts as a gateway for backend services, allowing developers to expose their APIs to external and internal consumers while applying policies for security, throttling, caching, and transformation, thus ensuring consistent and controlled API access.
You can configure the named values as you want.

Records for the publisher portal, management, gateway, developer portal and scm urls will be created in the private dns zone of .azure-api.net to enable private connectivity 

> **Note:**
>
>Due to pipeline time execution limit of 60 minutes, in case you need custom hostnames in APIM:
>
>- First execute the pipeline with: requires_custom_host_name_configuration = false
>- After APIM is deployed you can modify code and execute pipeline again with: requires_custom_host_name_configuration = true
>- Custom hostnames will be deployed without exceding the timeout per pipeline.
>

## Deployed Resources

---------------------------

These all resources will be deployed when using APIM module.

- azurerm_api_management  
- azurerm_network_security_rule  
- azurerm_api_management_logger  
- azurerm_api_management_backend
- azurerm_api_management_named_value
- azurerm_api_management_named_value
- azurerm_role_assignment
- azurerm_key_vault_access_policy (if custom hostname is needed)
- azurerm_api_management_custom_domain (if needed)

## Pre-requisites

----------------------------

- Resource Group
- Virtual Network
- Dedicated subnet (The Subnet must have a /28 or larger address space.)
- NSG associated to the subnet where the APIM will be deployed
- KeyVault
- Log Analytics Workspace (Optional)
- App Insights (Optional)
- Certificate Stored in Keyvault (if needed)

## Axso Naming convention example

----------------------------

The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-apim"`  
**NonProd:** `axso-np-appl-project-dev-apim`  
**Prod:** `axso-p-appl-project-prod-apim`

# Terraform Files

----------------------------

## module.tf

```hcl
module "apim" {
  source                                             = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_api_management?ref=v1.4.3"
  providers = {
    azurerm.dns = azurerm.dns
  }  
  location                                           = var.location
  environment                                        = var.environment
  project_name                                       = var.project_name
  resource_group_name                                = var.resource_group_name
  virtual_network_name                               = var.virtual_network_name
  virtual_network_resource_group_name                = var.virtual_network_resource_group_name
  virtual_network_type                               = var.virtual_network_type
  subnet_names                                       = var.subnet_names
  nsg_name                                           = var.nsg_name
  app_insights_name                                  = var.app_insights_name
  backend_services                                   = var.backend_services
  backend_protocol                                   = var.backend_protocol
  sku_name                                           = var.sku_name
  publisher_name                                     = var.publisher_name
  publisher_email                                    = var.publisher_email
  zones                                              = var.zones
  key_vault_name                                     = var.key_vault_name
  named_values                                       = var.named_values
  keyvault_named_values                              = var.keyvault_named_values
  wildcard_certificate_key_vault_name                = var.wildcard_certificate_key_vault_name
  wildcard_certificate_name                          = var.wildcard_certificate_name
  wildcard_certificate_key_vault_resource_group_name = var.wildcard_certificate_key_vault_resource_group_name
  requires_custom_host_name_configuration            = var.requires_custom_host_name_configuration
  developer_portal_host_name                         = var.developer_portal_host_name
  management_host_name                               = var.management_host_name
  gateway_host_name                                  = var.gateway_host_name
}
```

## module.tf.tfvars  

```hcl
environment                         = "dev"
project_name                        = "prj"
resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_name                = "vnet-ssp-nonprod-axso-vnet"
subnet_names                        = ["apim"]
virtual_network_resource_group_name = "axso-np-appl-ssp-test-rg"
nsg_name                            = "ssp-nonprod-axso-apim-nsg"
virtual_network_type                = "Internal"


sku_name        = "Premium_1"
publisher_name  = "Contoso ApiManager"
publisher_email = "api_manager@test.com"
zones           = []
key_vault_name  = "kv-ssp-0-nonprod-axso"

named_values = [
  {
    display_name = "apim-test-no-keyvault"
    name         = "apim-test-no-kv"
    value        = "my-secret-value"
    secret       = true
  },
  {
    display_name = "my-second-value"
    name         = "my-second-value"
    value        = "my-not-secret-value"
  }
]

keyvault_named_values = [
  {
    display_name = "apim-test-keyvault"
    name         = "apim-test-kv"
    value        = "apim-test" # Keyvault "secret name" that contains the secret value
    secret       = true
  }
]



app_insights_name = "axso-np-appl-ssp-dev-insights"
backend_protocol  = "http"
backend_services = [
  "admin-services-as",
  "user-services-as"
]

requires_custom_host_name_configuration = false #If custom names are needed. First set to false in first pipeline execution, then to true and run pipeline again
#wildcard_certificate_key_vault_name                = "kv-ssp-0-nonprod-axso" #make sure the certs are in this kv 
#wildcard_certificate_name                          = "nonprod-cloudinfra-axpo-cloud"
#wildcard_certificate_key_vault_resource_group_name = "axso-np-appl-ssp-test-rg"
#developer_portal_host_name                         = "developer.nonprod.cloudinfra.axpo.cloud"
#management_host_name                               = "management.nonprod.cloudinfra.axpo.cloud"
#gateway_host_name     

```

## variables.tfvars

```hcl

variable "location" {
  type        = string
  description = "The default location where the resource will be created"
  default     = "westeurope"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "project_name" {
  type        = string
  default     = "prj"
  description = "The name of the project."
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "virtual_network_type" {
  type        = string
  description = "The type of virtual network you want to use, valid values include: None, External, Internal."
  default     = "Internal"
}

variable "subnet_names" {
  type        = list(string)
  description = "The name of the subnet for the Azure resources."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network for the Azure resources."
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the virtual network."
}

variable "nsg_name" {
  type        = string
  description = "The name of the network security group."
}

variable "key_vault_name" {
  description = "Name of the Key Vault where the secrets are read"
  type        = string
  default     = null
}

variable "named_values" {
  description = "(Optional)Map containing the name of the named values as key and value as values"
  type        = list(map(string))
  default     = []
}

variable "keyvault_named_values" {
  description = "(Optional)Map containing the name of the named values as key and value as values. The secret is stored in keyvault"
  type        = list(map(string))
  default     = []
}

variable "sku_name" {
  type        = string
  description = "String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer, Basic, Standard and Premium. The second part is the capacity"
  default     = "Basic_1"
}

variable "publisher_name" {
  type        = string
  description = "The name of publisher/company."
  default     = null
}

variable "zones" {
  type        = list(number)
  description = "(Optional) Specifies a list of Availability Zones in which this API Management service should be located. Changing this forces a new API Management service to be created. Supported in Premium Tier."
  default     = [1, 2, 3]
}

variable "publisher_email" {
  type        = string
  description = "The email of publisher/company."
  default     = "mario.martinezdiez@axpo.com"
}

variable "app_insights_name" {
  type        = string
  default     = null
  description = "(Optional)In case you want to integrate APIM with application insights please specify name"
}

variable "backend_protocol" {
  type        = string
  default     = "http"
  description = "Protocol for the backend http or soap"
}


variable "backend_services" {
  type        = list(string)
  description = "(Optional)Include backend setting in case are needed"
  default     = []
}

variable "requires_custom_host_name_configuration" {
  type        = bool
  description = "If APIM requires custom hostname configuration"
  default     = false
}


variable "wildcard_certificate_key_vault_name" {
  type        = string
  description = "(Optional)Name of the keyvault containing the certificate"
  default     = null
}

variable "wildcard_certificate_name" {
  type        = string
  description = "(Optional)Name of the certificate"
  default     = null
}

variable "wildcard_certificate_key_vault_resource_group_name" {
  type        = string
  description = "(Optional)Resource group containing certificate keyvault"
  default     = null
}

variable "developer_portal_host_name" {
  type        = string
  description = "(Optional)Name for the developers portal URL"
  default     = null
}

variable "management_host_name" {
  type        = string
  description = "(Optional)Name for the management portal URL"
  default     = null
}


variable "gateway_host_name" {
  type        = string
  description = "(Optional)Name for the gateway URL"
  default     = null
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

provider "azurerm" {
  alias           = "dns"
  subscription_id = "36cae50e-ce2a-438f-bd97-216b7f682c77"
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
| <a name="provider_azurerm.dns"></a> [azurerm.dns](#provider\_azurerm.dns) | ~> 4.0 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) | resource |
| [azurerm_api_management_backend.apim_backends](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_backend) | resource |
| [azurerm_api_management_custom_domain.apim_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_custom_domain) | resource |
| [azurerm_api_management_logger.app_insight_integration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_logger) | resource |
| [azurerm_api_management_named_value.keyvault_named_values](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.named_values](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_policy.api_management_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_policy) | resource |
| [azurerm_key_vault_access_policy.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_network_security_rule.management_apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_a_record.developer_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.gateway_hostname_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.management_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.portal_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.scm_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_role_assignment.keyvault_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_application_insights.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.key_vault_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_certificate.cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_secret.key_vault_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_location"></a> [additional\_location](#input\_additional\_location) | List of the name of the Azure Region in which the API Management Service should be expanded to. | `list(map(string))` | `[]` | no |
| <a name="input_app_insights_name"></a> [app\_insights\_name](#input\_app\_insights\_name) | (Optional)In case you want to integrate APIM with application insights please specify name | `string` | `null` | no |
| <a name="input_backend_protocol"></a> [backend\_protocol](#input\_backend\_protocol) | Protocol for the backend http or soap | `string` | `"http"` | no |
| <a name="input_backend_services"></a> [backend\_services](#input\_backend\_services) | Include backend setting in case are needed | `list(string)` | n/a | yes |
| <a name="input_certificate_configuration"></a> [certificate\_configuration](#input\_certificate\_configuration) | List of certificate configurations | `list(map(string))` | `[]` | no |
| <a name="input_client_certificate_enabled"></a> [client\_certificate\_enabled](#input\_client\_certificate\_enabled) | (Optional) Enforce a client certificate to be presented on each request to the gateway? This is only supported when SKU type is `Consumption`. | `bool` | `false` | no |
| <a name="input_create_management_rule"></a> [create\_management\_rule](#input\_create\_management\_rule) | Whether to create the NSG rule for the management port of the APIM. If true, nsg\_name variable must be set | `bool` | `true` | no |
| <a name="input_custom_management_rule_name"></a> [custom\_management\_rule\_name](#input\_custom\_management\_rule\_name) | Custom NSG rule name for APIM Management. | `string` | `"default-management-apim-rule"` | no |
| <a name="input_developer_portal_host_name"></a> [developer\_portal\_host\_name](#input\_developer\_portal\_host\_name) | (Optional)Name for the developers portal URL | `string` | `null` | no |
| <a name="input_developer_portal_hostname_configuration"></a> [developer\_portal\_hostname\_configuration](#input\_developer\_portal\_hostname\_configuration) | Developer portal hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Should HTTP/2 be supported by the API Management Service? | `bool` | `false` | no |
| <a name="input_enable_sign_in"></a> [enable\_sign\_in](#input\_enable\_sign\_in) | Should anonymous users be redirected to the sign in page? | `bool` | `false` | no |
| <a name="input_enable_sign_up"></a> [enable\_sign\_up](#input\_enable\_sign\_up) | Can users sign up on the development portal? | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_gateway_disabled"></a> [gateway\_disabled](#input\_gateway\_disabled) | (Optional) Disable the gateway in main region? This is only supported when `additional_location` is set. | `bool` | `false` | no |
| <a name="input_gateway_host_name"></a> [gateway\_host\_name](#input\_gateway\_host\_name) | (Optional) Name for the gateway URL | `string` | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | A list of IDs for User Assigned Managed Identity resources to be assigned. This is required when type is set to UserAssigned or SystemAssigned, UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of Managed Service Identity that should be configured on this API Management Service | `string` | `"SystemAssigned"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the Key Vault where the secrets are read | `string` | `null` | no |
| <a name="input_keyvault_named_values"></a> [keyvault\_named\_values](#input\_keyvault\_named\_values) | Map containing the name of the named values as key and value as values. The secret is stored in keyvault | `list(map(string))` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the resource will be created | `string` | `"westeurope"` | no |
| <a name="input_management_host_name"></a> [management\_host\_name](#input\_management\_host\_name) | (Optional)Name for the management portal URL | `string` | `null` | no |
| <a name="input_management_hostname_configuration"></a> [management\_hostname\_configuration](#input\_management\_hostname\_configuration) | List of management hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_management_nsg_rule_priority"></a> [management\_nsg\_rule\_priority](#input\_management\_nsg\_rule\_priority) | Priority of the NSG rule created for the management port of the APIM | `number` | `101` | no |
| <a name="input_min_api_version"></a> [min\_api\_version](#input\_min\_api\_version) | (Optional) The version which the control plane API calls to API Management service are limited with version equal to or newer than. | `string` | `null` | no |
| <a name="input_named_values"></a> [named\_values](#input\_named\_values) | Map containing the name of the named values as key and value as values | `list(map(string))` | `[]` | no |
| <a name="input_notification_sender_email"></a> [notification\_sender\_email](#input\_notification\_sender\_email) | Email address from which the notification will be sent | `string` | `null` | no |
| <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name) | NSG name of the subnet hosting the APIM to add the rule to allow management if the APIM is private | `string` | `null` | no |
| <a name="input_nsg_rg_name"></a> [nsg\_rg\_name](#input\_nsg\_rg\_name) | Name of the RG hosting the NSG if it's different from the one hosting the APIM | `string` | `null` | no |
| <a name="input_policy_configuration"></a> [policy\_configuration](#input\_policy\_configuration) | Map of policy configuration | `map(string)` | `{}` | no |
| <a name="input_portal_hostname_configuration"></a> [portal\_hostname\_configuration](#input\_portal\_hostname\_configuration) | Legacy portal hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"prj"` | no |
| <a name="input_proxy_hostname_configuration"></a> [proxy\_hostname\_configuration](#input\_proxy\_hostname\_configuration) | List of proxy hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_publisher_email"></a> [publisher\_email](#input\_publisher\_email) | The email of publisher/company. | `string` | `"mario.martinezdiez@axpo.com"` | no |
| <a name="input_publisher_name"></a> [publisher\_name](#input\_publisher\_name) | The name of publisher/company. | `string` | `null` | no |
| <a name="input_requires_custom_host_name_configuration"></a> [requires\_custom\_host\_name\_configuration](#input\_requires\_custom\_host\_name\_configuration) | If APIM requires custom hostname configuration | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_scm_hostname_configuration"></a> [scm\_hostname\_configuration](#input\_scm\_hostname\_configuration) | List of scm hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_security_configuration"></a> [security\_configuration](#input\_security\_configuration) | Map of security configuration | `map(string)` | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer, Basic, Standard and Premium. The second part is the capacity | `string` | `"Basic_1"` | no |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | The name of the subnet for the Azure resources. | `list(string)` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_terms_of_service_configuration"></a> [terms\_of\_service\_configuration](#input\_terms\_of\_service\_configuration) | Map of terms of service configuration | `list(map(string))` | <pre>[<br/>  {<br/>    "consent_required": false,<br/>    "enabled": false,<br/>    "text": ""<br/>  }<br/>]</pre> | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network for the Azure resources. | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group that contains the virtual network. | `string` | n/a | yes |
| <a name="input_virtual_network_type"></a> [virtual\_network\_type](#input\_virtual\_network\_type) | The type of virtual network you want to use, valid values include: None, External, Internal. | `string` | `"Internal"` | no |
| <a name="input_wildcard_certificate_key_vault_name"></a> [wildcard\_certificate\_key\_vault\_name](#input\_wildcard\_certificate\_key\_vault\_name) | (Optional)Name of the keyvault containing the certificate | `string` | `null` | no |
| <a name="input_wildcard_certificate_key_vault_resource_group_name"></a> [wildcard\_certificate\_key\_vault\_resource\_group\_name](#input\_wildcard\_certificate\_key\_vault\_resource\_group\_name) | (Optional)Resource group containing certificate keyvault | `string` | `null` | no |
| <a name="input_wildcard_certificate_name"></a> [wildcard\_certificate\_name](#input\_wildcard\_certificate\_name) | (Optional)Name of the certificate | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) Specifies a list of Availability Zones in which this API Management service should be located. Changing this forces a new API Management service to be created. Supported in Premium Tier. | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_linux_web_app?repoName=azurerm_linux_web_app&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2464&repoName=azurerm_linux_web_app&branchName=main) | **v5.1.5** | 25/03/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Linux App Service Configuration](#linux-app-service-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# Linux App Service Configuration

----------------------------

[Learn more about Linux App Service in the Microsoft Documentation](https://learn.microsoft.com/en-us/azure/app-service/overview/?wt.mc_id=DT-MVP-5004771)

This module allows deploying Azure App Service Plans with the necessary App Services, and also allows deploying slots if needed. It enables specifying the configurations and versions for Linux-type App Services, adds the identity block, and creates a private endpoint.

>**Note:**  
>
>- If you need to use an Azure container registry use_acr should be true in module.tf.tfvars
>- If you need system managed identity to have permission into that ACR acr_use_managed_identity_credentials should be true in module.tf.tfvars
>- docker_registry_url is required if Application stack is docker  
>- acr_name is required if you require to use acr_use_managed_identity_credential  
>- In case you need to specify some configuration values for the App is better to build it in locals
>

## Service Description

----------------------------

**Linux App Service Plan:**  
Is a resource that defines the underlying infrastructure that hosts one or more Azure Web Apps. It specifies the location, size, and features of the VMs that run the apps, such as CPU, memory, and scaling options. Each App Service Plan can host multiple web applications, allowing you to optimize resource utilization and scale your apps independently.

**App Services:**
Is a fully managed platform for building, deploying, and scaling web applications and APIs. It provides features like automatic scaling, continuous deployment, custom domains, SSL certificates, and integration with Azure services and DevOps tools. App Services support multiple programming languages, frameworks, and runtime environments, enabling builders to build and deploy applications quickly without managing underlying infrastructure.  
Deployment inbound network access is secured by adding a private endpoint, that offers secure and private access to Azure services

**Deployment Slots:**  
Are live instances of an Azure Web App that allow you to deploy and test changes to your application before swapping them into production. Each slot is a separate environment with its own URL and settings, but they share the same App Service Plan resources. Are useful for staging, testing, and gradually rolling out updates without affecting the production environment, and they support features like auto-swap and traffic routing rules.

## Deployed Resources

----------------------------
This module will deploy the following azurerm resources:

- azurerm_service_plan
- azurerm_linux_web_app
- azurerm_role_assignment (If ACR is needed)
- azurerm_linux_web_app_slot (optional)
- azurerm_app_service_virtual_network_swift_connection
- azurerm_private_endpoint

If certificate/custom domain is configured:

- azurerm_role_assignment
- azurerm_app_service_certificate
- azurerm_private_dns_a_record
- azurerm_dns_txt_record
- azurerm_app_service_custom_hostname_binding
- azurerm_app_service_certificate_binding

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Vnet integration (When needed)
- Subnet for Private endpoint deployment
- Azure Container registry (When needed)
- Certificate stored in keyvault (When needed)

## Axso Naming convention example

----------------------------

**App Service Plan**
The naming convention is derived from the following variables `subscription`, `project_name` ,`environment`, `service_plan_os_type`, `service_plan_usage`

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.service_plan_os_type}-${var.service_plan_usage}-asp"`  
**NonProd:** `"axso-np-appl-ssp-dev-linux-billing-asp"`  
**Prod:** `"axso-p-appl-ssp-prod-linux-billing-asp"`  

**App Service**
The naming convention is derived from the following variables `subscription`, `project_name` ,`environment`, `appservice_short_description`

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.service_plan_os_type}-${var.appservice_short_description}-as"`  
**NonProd:** `axso-np-appl-ssp-dev-checkers-as`  
**Prod:** `axso-p-appl-ssp-prod-checkers-as`  

**Deployment Slots**
The naming convention is derived from the following variables `subscription`, `project_name` ,`environment`, `appservice_short_description`, `deployment_slot_name`

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.service_plan_os_type}-${var.appservice_short_description}-as-${var.deployment_slot_name}"`  
**NonProd:** `axso-np-appl-ssp-dev-checkers-as-slot`  
**Prod:** `axso-p-appl-ssp-prod-checkers-as-slot`  

**Private Endpoints (Web Apps)**
The naming convention is derived from the following variables `subscription`, `project_name` ,`environment`, `appservice_short_description`

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.service_plan_os_type}-${var.appservice_short_description}-as-pe"`  
**NonProd:** `axso-np-appl-ssp-dev-checkers-as-pe`  
**Prod:** `axso-p-appl-ssp-prod-checkers-as-pe`  

**Private Endpoints (Deployment Slots)**
The naming convention is derived from the following variables `subscription`, `project_name` ,`environment`, `appservice_short_description`, `deployment_slot_name`

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.service_plan_os_type}-${var.appservice_short_description}-as-${var.deployment_slot_name}-pe"`  
**NonProd:** `axso-np-appl-ssp-dev-checkers-as-slot-pe`  
**Prod:** `axso-p-appl-ssp-prod-checkers-as-slot-pe`  

## Terraform Files

----------------------------

## module.tf

```hcl

module "webapps" {

  source   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_web_app?ref=5.1.0"
  location = var.location
  providers = {
    azurerm.dns = azurerm.dns
  }
  resource_group_name                  = var.resource_group_name
  project_name                         = var.project_name
  subscription                         = var.subscription
  environment                          = var.environment
  service_plan_sku_name                = var.service_plan_sku_name
  service_plan_os_type                 = var.service_plan_os_type
  service_plan_usage                   = var.service_plan_usage
  app_services                         = var.app_services
  deployment_slots                     = var.deployment_slots
  default_documents                    = var.default_documents
  app_settings                         = var.app_settings
  network_resource_group_name          = var.network_resource_group_name
  virtual_network_name                 = var.virtual_network_name
  vint_subnet_name                     = var.vint_subnet_name
  pe_subnet_name                       = var.pe_subnet_name
  docker_registry_url                  = var.docker_registry_url
  acr_name                             = var.acr_name
  umids                                = var.umid_names
  private_dns_zone_name                = var.private_dns_zone_name
  public_dns_zone_name                 = var.public_dns_zone_name
  webapp_custom_certificates_key_vault = var.webapp_custom_certificates_key_vault
  webapp_custom_certificates           = var.webapp_custom_certificates
  webapp_custom_domains                = var.webapp_custom_domains
}

```

## module.tf.tfvars

```hcl

location                    = "West Europe"
environment                 = "dev"
project_name                = "ssp"
subscription                = "np"
resource_group_name         = "axso-np-appl-ssp-test-rg"
network_resource_group_name = "rg-cloudinfra-nonprod-axso-ymiw"
virtual_network_name        = "vnet-cloudinfra-nonprod-axso-e3og"
vint_subnet_name            = "app-linux-subnet"
pe_subnet_name              = "pe"
docker_registry_url         = "https://axso4np4ssp4shared4acr01.azurecr.io"
acr_name                    = "axso4np4ssp4shared4acr01"

service_plan_sku_name = "P1v3"
service_plan_usage    = "billing"
service_plan_os_type  = "Linux"

umid_names = [
  "axso-np-appl-ssp-test-umid"
]

app_settings = {
  developers_settings = {
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    WEBSITE_NODE_DEFAULT_VERSION               = "16.16.0"
  },

  testers_settings = {
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"

  },

  quality_settings = {
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"

  }
}

app_services = [
  {
    appservice_short_description         = "builders",
    app_settings_name                    = "builders_settings",
    use_acr                              = false,
    acr_use_managed_identity_credentials = false,
    identity_type                        = null
    ftps_state                           = "FtpsOnly",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    vnet_integ_required                  = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "python",
    docker_image_name                    = "",
    dotnet_version                       = "",
    python_version                       = "3.11"

  },

  {
    appservice_short_description         = "producers",
    app_settings_name                    = "producers_settings",
    use_acr                              = false,
    acr_use_managed_identity_credentials = false,
    identity_type                        = "UserAssigned",
    ftps_state                           = "FtpsOnly",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    vnet_integ_required                  = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "dotnet",
    docker_image_name                    = "",
    dotnet_version                       = "6.0",
    python_version                       = ""

  },

  {
    appservice_short_description         = "checkers",
    app_settings_name                    = "checkers_settings",
    use_acr                              = true,
    acr_use_managed_identity_credentials = true,
    identity_type                        = "SystemAssigned",
    ftps_state                           = "FtpsOnly",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    vnet_integ_required                  = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "docker",
    docker_image_name                    = "samples/helloworld",
    dotnet_version                       = "",
    python_version                       = ""

  }
]

deployment_slots = [
  {
    deployment_slot_name                 = "stage",
    appservice_short_description         = "builders",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    app_settings_name                    = "builders_settings",
    use_acr                              = false,
    acr_use_managed_identity_credentials = false,
    identity_type                        = "SystemAssigned",
    ftps_state                           = "FtpsOnly"
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "python",
    docker_image_name                    = "",
    dotnet_version                       = "",
    python_version                       = "3.11"
  },
  {
    deployment_slot_name                 = "stage2",
    appservice_short_description         = "builders",
    client_affinity_enabled              = true,
    worker_count                         = 1,
    app_settings_name                    = "builders_settings",
    use_acr                              = false,
    acr_use_managed_identity_credentials = false,
    identity_type                        = null
    ftps_state                           = "FtpsOnly"
    always_on                            = true,
    websockets_enabled                   = true,
    health_check_path                    = "/health",
    health_check_eviction_time_in_min    = 2,
    vnet_route_all_enabled               = true,
    subnetname                           = "app-linux-subnet",
    application_stack                    = "dotnet",
    docker_image_name                    = "",
    dotnet_version                       = "6.0",
    python_version                       = ""
  }
]

private_dns_zone_name = "nonprod.cloudinfra.axpo.cloud"
public_dns_zone_name  = "cloudinfra.axpo.cloud"

webapp_custom_certificates_key_vault = "kv-ssp-0-nonprod-axso"

webapp_custom_certificates = {
  "webapp-c-1" = {
    keyvault_certificate_name        = "nonprod-cloudinfra-axpo-cloud" # The name of your certificate store in the KV
    webapp_certificate_friendly_name = "nonprod-cloudinfra-axpo-cloud"
  },
  "webapp-c-2" = {
    keyvault_certificate_name        = "front-nonprod-cloudinfra-axpo-cloud" # The name of your certificate store in the KV
    webapp_certificate_friendly_name = "front-nonprod-cloudinfra-axpo-cloud"
  }
}

webapp_custom_domains = {
  "builders" = {
    webapp_description               = "builders" #The description of the webapp, same as in app_services
    webapp_certificate_friendly_name = "nonprod-cloudinfra-axpo-cloud"
    webapp_custom_domain_name        = "builders" # The domain will be added, so this is developers.nonprod.cloudinfra.axpo.cloud, if you want only nonprod.cloudinfra.axpo.cloud, use "@""
  },
  "producers" = {
    webapp_description               = "producers" #The description of the webapp, same as in app_services
    webapp_certificate_friendly_name = "nonprod-cloudinfra-axpo-cloud"
    webapp_custom_domain_name        = "producers" # The domain will be added, so this is testers.nonprod.cloudinfra.axpo.cloud, if you want only nonprod.cloudinfra.axpo.cloud, use "@""
  },                                               #, #This is an example just for reference
  "checkers" = {
    webapp_description               = "checkers" #The description of the webapp, same as in app_services
    webapp_certificate_friendly_name = "front-nonprod-cloudinfra-axpo-cloud"
    webapp_custom_domain_name        = "front" # The domain will be added, so this is performance.nonprod.cloudinfra.axpo.cloud, if you want only nonprod.cloudinfra.axpo.cloud, use "@""
  }
}


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

variable "service_plan_sku_name" {
  type        = string
  description = "The SKU for the plan. Possible values include B1, I3, P1v2"
}

variable "service_plan_usage" {
  type        = string
  description = "Short description to identify or diferentiate your App services plans"
}

variable "service_plan_os_type" {
  type        = string
  default     = "Linux"
  description = "Type of the for the App Service Plan i.e Linux"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created."
}

variable "umid_names" {
  description = "(Optional)List of User Assigned Managed Identity Names"
  type        = list(string)
  default     = []
}


variable "docker_registry_url" {
  type        = string
  default     = ""
  description = "(Optional)URL of the docker registry"
}

variable "acr_name" {
  type        = string
  default     = null
  description = "(Optional)Azure COntainer Registry name"
}

variable "app_services" {
  description = "Add details for your App services"
  type = list(object({
    appservice_short_description         = string,
    app_settings_name                    = string,
    use_acr                              = bool, # If true give var.acr_name
    acr_use_managed_identity_credentials = bool,
    identity_type                        = string,
    client_affinity_enabled              = bool,
    worker_count                         = number,
    ftps_state                           = string,
    always_on                            = bool,
    websockets_enabled                   = bool,
    health_check_path                    = string,
    health_check_eviction_time_in_min    = number,
    vnet_route_all_enabled               = bool,
    subnetname                           = string,
    application_stack                    = string,
    docker_image_name                    = string,
    dotnet_version                       = string,
    python_version                       = string

  }))
}

variable "app_settings" {
  type        = map(any)
  description = "values for the app settings"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network for the Azure resources."
}

variable "vint_subnet_name" {
  type    = string
  default = "Subnet name for Integrating in Webapps"
}

variable "pe_subnet_name" {
  type    = string
  default = "Subnet name for the private endpoint"
}

variable "network_resource_group_name" {
  type        = string
  description = "The name of the resource group where the virtual network is created"

}

variable "default_documents" {
  type        = list(string)
  default     = ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php", "hostingstart.html"]
  description = "Default documents to be added"
}

variable "deployment_slots" {
  description = "Add details for your App services Slots"
  type = list(object({
    deployment_slot_name                 = string,
    appservice_short_description         = string,
    client_affinity_enabled              = bool,
    worker_count                         = number,
    app_settings_name                    = string,
    use_acr                              = bool, # If true give var.acr_name
    acr_use_managed_identity_credentials = bool,
    identity_type                        = string,
    ftps_state                           = string,
    always_on                            = bool,
    websockets_enabled                   = bool,
    health_check_path                    = string,
    health_check_eviction_time_in_min    = number,
    vnet_route_all_enabled               = bool,
    subnetname                           = string,
    application_stack                    = string,
    docker_image_name                    = string,
    dotnet_version                       = string,
    python_version                       = string
  }))
  default = []
}

variable "private_dns_zone_name" {
  type        = string
  description = "(Optional) The domain name for the custom private domain dns zone."
  default     = "nonprod.cloudinfra.axpo.cloud"
}

variable "public_dns_zone_name" {
  type        = string
  description = "(Optional) The domain name for the custom public domain dns zone."
  default     = "cloudinfra.axpo.cloud"
}

variable "webapp_custom_certificates_key_vault" {
  type        = string
  description = "(Optional) The name of the Key Vault where the custom certificates are stored."
  default     = null
}

variable "webapp_custom_certificates" {
  type = map(object({
    keyvault_certificate_name        = string
    webapp_certificate_friendly_name = string
  }))
  description = "(Optional) The list of Custom certificates to use in the web apps stored in the webapp_custom_certificates_key_vault."
  default     = {}
}

variable "webapp_custom_domains" {
  type = map(object({
    webapp_description               = string
    webapp_certificate_friendly_name = string
    webapp_custom_domain_name        = string
  }))
  description = "(Optional) The list of Custom domains to use in the web apps."
  default     = {}
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
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |
| <a name="provider_azurerm.dns"></a> [azurerm.dns](#provider\_azurerm.dns) | ~> 4.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_certificate.app_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate) | resource |
| [azurerm_app_service_certificate_binding.certificate_binding](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.hostname_binding](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_virtual_network_swift_connection.azure_vnet_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) | resource |
| [azurerm_dns_txt_record.txt_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record) | resource |
| [azurerm_linux_web_app.lin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app_slot.deployment_slot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app_slot) | resource |
| [azurerm_private_dns_a_record.pe_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.private_endpoint_slots](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.pull_image](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.pull_image_umid](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.webapp_role_assignment_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.azure_serviceplan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_30_seconds_destroy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_service_principal.MicrosoftWebApp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_container_registry.acr_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |
| [azurerm_key_vault.webapp_cert_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subnet.pe_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.vint_subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.webapp_umids](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | (Optional) Name of the ACR if ACR is enabled per app | `string` | `null` | no |
| <a name="input_app_services"></a> [app\_services](#input\_app\_services) | Add details for your App services | <pre>list(object({<br/>    appservice_short_description         = string,<br/>    app_settings_name                    = string,<br/>    use_acr                              = bool, # If true give var.acr_name <br/>    acr_use_managed_identity_credentials = bool,<br/>    identity_type                        = string,<br/>    client_affinity_enabled              = bool,<br/>    worker_count                         = number,<br/>    ftps_state                           = string,<br/>    always_on                            = bool,<br/>    websockets_enabled                   = bool,<br/>    health_check_path                    = string,<br/>    health_check_eviction_time_in_min    = number,<br/>    vnet_route_all_enabled               = bool,<br/>    subnetname                           = string,<br/>    application_stack                    = string,<br/>    docker_image_name                    = string,<br/>    dotnet_version                       = string,<br/>    python_version                       = string<br/>  }))</pre> | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | values for the app settings | `map(any)` | n/a | yes |
| <a name="input_default_documents"></a> [default\_documents](#input\_default\_documents) | Default documents to be added | `list(string)` | <pre>[<br/>  "Default.htm",<br/>  "Default.html",<br/>  "Default.asp",<br/>  "index.htm",<br/>  "index.html",<br/>  "iisstart.htm",<br/>  "default.aspx",<br/>  "index.php",<br/>  "hostingstart.html",<br/>  "client/build/index.html"<br/>]</pre> | no |
| <a name="input_deployment_slots"></a> [deployment\_slots](#input\_deployment\_slots) | Add details for your App services Slots | <pre>list(object({<br/>    deployment_slot_name                 = string,<br/>    appservice_short_description         = string,<br/>    client_affinity_enabled              = bool,<br/>    worker_count                         = number,<br/>    app_settings_name                    = string,<br/>    acr_use_managed_identity_credentials = bool,<br/>    identity_type                        = string,<br/>    ftps_state                           = string,<br/>    always_on                            = bool,<br/>    websockets_enabled                   = bool,<br/>    health_check_path                    = string,<br/>    health_check_eviction_time_in_min    = number,<br/>    vnet_route_all_enabled               = bool,<br/>    subnetname                           = string,<br/>    application_stack                    = string,<br/>    docker_image_name                    = string,<br/>    dotnet_version                       = string,<br/>    python_version                       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_docker_registry_url"></a> [docker\_registry\_url](#input\_docker\_registry\_url) | (Optional) Name of the Docker Registry URL | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the App service will be created | `string` | n/a | yes |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The name of the resource group where the virtual network is created | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | n/a | `string` | `"Subnet name for the private endpoint"` | no |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | (Optional) The domain name for the custom private domain dns zone. | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_public_dns_zone_name"></a> [public\_dns\_zone\_name](#input\_public\_dns\_zone\_name) | (Optional) The domain name for the custom public domain dns zone. | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where your resources should reside | `string` | n/a | yes |
| <a name="input_service_plan_os_type"></a> [service\_plan\_os\_type](#input\_service\_plan\_os\_type) | Type of the for the App Service Plan i.e Windows, Linux | `string` | n/a | yes |
| <a name="input_service_plan_sku_name"></a> [service\_plan\_sku\_name](#input\_service\_plan\_sku\_name) | The SKU for the plan. Possible values include B1, I3, P1v2 | `string` | n/a | yes |
| <a name="input_service_plan_usage"></a> [service\_plan\_usage](#input\_service\_plan\_usage) | Short description to identify or diferentiate your App services plans | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |
| <a name="input_umids"></a> [umids](#input\_umids) | (Optional)Specifies a list of User Assigned Managed Identity IDs to be assigned to this Web App. | `list(string)` | `[]` | no |
| <a name="input_vint_subnet_name"></a> [vint\_subnet\_name](#input\_vint\_subnet\_name) | n/a | `string` | `"Subnet name for Integrating in Webapps"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | n/a | `string` | `"Name of the virtual Network"` | no |
| <a name="input_webapp_custom_certificates"></a> [webapp\_custom\_certificates](#input\_webapp\_custom\_certificates) | (Optional) The list of Custom certificates to use in the web apps stored in the webapp\_custom\_certificates\_key\_vault. | <pre>map(object({<br/>    keyvault_certificate_name        = string<br/>    webapp_certificate_friendly_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_webapp_custom_certificates_key_vault"></a> [webapp\_custom\_certificates\_key\_vault](#input\_webapp\_custom\_certificates\_key\_vault) | (Optional) The name of the Key Vault where the custom certificates are stored. | `string` | `null` | no |
| <a name="input_webapp_custom_domains"></a> [webapp\_custom\_domains](#input\_webapp\_custom\_domains) | (Optional) The list of Custom domains to use in the web apps. | <pre>map(object({<br/>    webapp_description               = string<br/>    webapp_certificate_friendly_name = string<br/>    webapp_custom_domain_name        = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_ids"></a> [app\_service\_ids](#output\_app\_service\_ids) | The App Service IDs |
| <a name="output_app_service_names"></a> [app\_service\_names](#output\_app\_service\_names) | The App Service Names |
<!-- END_TF_DOCS -->

| **Build Status** | **Latest Version** | **Date** |
|:-----------------|:-------------------|:---------|
| [![Build Status](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_apis/build/status%2FProd_Branch_Testing%2Fazurerm_application_gateway?repoName=azurerm_application_gateway&branchName=main)](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_build/latest?definitionId=2508&repoName=azurerm_application_gateway&branchName=main) | **v1.3.4** | 24/02/2025 |  

To see more available Axso services please see **[Production Ready Services](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3912/PRODUCTION.SERVICES)** or **[Production Ready Blueprints](https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_wiki/wikis/Axso%20Terraform%20Self%20Service/3911/PRODUCTION.BLUEPRINTS)**  

# INDEX

----------------------------

1. [Resource Configuration](#application-gateway-configuration)
2. [Terraform Files](#terraform-files)
3. [Input Description](#input-description)

# [Application Gateway Configuration](https://learn.microsoft.com/en-us/azure/application-gateway/?wt.mc_id=DT-MVP-5004771)

----------------------------

This module is designed to deploy an Azure Application Gateway, which is a web traffic load balancer that enables you to manage traffic to your web applications. It offers features such as SSL termination, URL-based routing, Web Application Firewall (WAF) capabilities, and support for multiple site hosting. By using this module, you can configure the Application Gateway with various settings, including backend pools, HTTP listeners, routing rules, and probes, allowing you to build a scalable and secure infrastructure for your web applications in the Azure cloud.

## Service Description

----------------------------
**Azure Application Gateway:** Is a web traffic load balancer that enables you to manage traffic to your web applications. It offers features such as SSL termination, URL-based routing, Web Application Firewall (WAF) capabilities, and support for multiple site hosting. By using this module, you can configure the Application Gateway with various settings, including backend pools, HTTP listeners, routing rules, and probes, allowing you to build a scalable and secure infrastructure for your web applications in the Azure cloud.

## Deployed Resources

----------------------------

- azurerm_user_assigned_identity
- azurerm_key_vault_access_policy
- azurerm_role_assignment
- azurerm_public_ip
- azurerm_application_gateway
- azurerm_network_interface
- azurerm_network_interface_application_gateway_backend_address_pool_association

## Pre-requisites

----------------------------

It is assumed that the following resources already exists:

- Resource Group
- Subnet for Vnet integration
- User managed identity (When needed)
- KeyVault
- Certificate stored in Keyvault

## Axso Naming convention example

----------------------------
The naming convention is derived from the following variables `subscription`, `project_name` and `environment`:  

**Construct:** `"axso-${var.subscription}-appl-${var.project_name}-${var.environment}-appgw"`  
**NonProd:** `axso-np-appl-project-dev-appgw`  
**Prod:** `axso-p-appl-project-prod-appgw`

## Terraform Files

----------------------------

## module.tf

```hcl
module "appgwV2" {
  source                              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_application_gateway?ref=v1.3.4"
  resource_group_name                 = var.resource_group_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  location                            = var.location

  key_vault_name = var.key_vault_name
  key_vault_rbac = var.key_vault_rbac

  subnet_name   = var.vint_subnet_name 
  vnet_name     = var.virtual_network_name
  private_ip    = var.frontend_ip_private
  appgw_public  = var.appgw_public
  frontend_port = var.frontend_port

  backend_address_pools = var.backend_address_pools
  backend_http_settings = var.backend_http_settings

  ssl_certificates_keyvault = [
    {
      name                               = var.name
      key_vault_secret_or_certificate_id = var.key_vault_secret_or_certificate_id
    }
  ]

  http_listeners        = var.http_listeners
  probes                = var.probes
  request_routing_rules = var.request_routing_rules
  waf_enabled           = var.waf_enabled
  waf_mode              = var.waf_mode
  sku_name              = var.sku_name
  sku_tier              = var.sku_tier
  capacity              = { min = var.capacity_min, max = var.capacity_max }
}
```

## module.tf.tfvars

```hcl
subscription                        = "np"
project_name                        = "prj"
environment                         = "dev"
location                            = "westeurope"
name                                = "test"
resource_group_name                 = "axso-np-appl-ssp-test-rg"
virtual_network_name                = "vnet-ssp-nonprod-axso-vnet"
key_vault_name                      = "kv-ssp-0-nonprod-axso"
key_vault_secret_or_certificate_id  = "https://kv-ssp-0-nonprod-axso.vault.azure.net/secrets/test/39d478f59bf14e45ab36a630a7a87db9"
virtual_network_resource_group_name = "axso-np-appl-ssp-test-rg"
vint_subnet_name                    = "appgw-subnet"

frontend_ip_private = "10.0.3.10"
frontend_port       = ["443"]

key_vault_rbac = true
appgw_public   = true

backend_address_pools = [
  {
    name  = "test-beap"
    ip    = ["10.0.4.4"]
    fqdns = []
  }
]
backend_http_settings = [
  {
    cookie_based_affinity           = "Disabled"
    name                            = "test-be-htst"
    path                            = ""
    port                            = "80"
    protocol                        = "Http"
    request_timeout                 = "20"
    host_name                       = "test.corp"
    probe_name                      = "test-probe"
    connection_draining_enabled     = false
    connection_draining_timeout_sec = "30"
    pick_hostname                   = false
  }
]


http_listeners = [
  {
    name                 = "test-httplstn"
    frontend_port_number = "443"
    protocol             = "Https"
    ssl_certificate_name = "test"
    host_name            = "test.com"
    require_sni          = false
  }
]

probes = [
  {
    name                  = "test-probe"
    interval              = "2"
    timeout               = "5"
    protocol              = "Http"
    path                  = "/"
    unhealthy_threshold   = "2"
    match_status_code     = ["200"]
    pick_hostname_backend = false
    host                  = "test.corp"
  }
]

request_routing_rules = [
  {
    name                        = "test-rqrt"
    priority                    = 1
    http_listener_name          = "test-httplstn"
    backend_address_pool_name   = "test-beap"
    backend_http_settings_name  = "test-be-htst"
    rule_type                   = "Basic"
    url_path_map_name           = ""
    redirect_configuration_name = ""
  }
]

waf_enabled  = true
waf_mode     = "Prevention"
sku_name     = "WAF_v2"
sku_tier     = "WAF_v2"
capacity_min = 1
capacity_max = 2


```

## variables.tf

```hcl
variable "location" {
  type        = string
  description = "The default location where the core network will be created"
  default     = "westeurope"
}

variable "project_name" {
  type        = string
  description = "The name of the project. e.g. MDS"
  default     = "prj"
}

variable "subscription" {
  type        = string
  description = "The subscription type e.g. 'p' for prod or 'np' for nonprod"
  default     = "np"
}

variable "environment" {
  type        = string
  description = "The environment. e.g. dev, qa, uat, prod"
  default     = "dev"
}

variable "name" {
  type        = string
  description = "(Required) The name of WAF Or App GW to create."
  default     = "test"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Application Gateway."
  default     = "rg-test"

}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the virtual network."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) The name of the virtual network in which to create the Application Gateway."
  default     = "vnet-test"

}

variable "vint_subnet_name" {
  type    = string
  default = "Subnet name for Integrating in Webapps"
}


variable "key_vault_name" {
  type        = string
  description = "(Required) The name of the Key Vault in which to create the Application Gateway."
  default     = "kv-test"

}

variable "key_vault_secret_or_certificate_id" {
  type        = string
  description = "(Required) The name of the secret or certificate ID."
  
}

variable "frontend_ip_private" {
  type        = string
  description = "The private IP address for the Application Gateway frontend."
}

variable "frontend_port" {
  type        = list(string)
  description = "(Required) The frontend ports used by the listener."
}

variable "key_vault_rbac" {
  type        = bool
  description = "Whether to enable RBAC for the Key Vault."
}

variable "appgw_public" {
  type        = bool
  description = "Whether the Application Gateway should have public exposure."
}

variable "backend_address_pools" {
  type = list(object({
    name  = string
    ip    = list(string)
    fqdns = list(string)
  }))
  description = "(Required) The backend address pools for the Application Gateway."
}

variable "backend_http_settings" {
  type = list(object({
    cookie_based_affinity           = string
    name                            = string
    path                            = string
    port                            = number
    protocol                        = string
    request_timeout                 = number
    host_name                       = string
    probe_name                      = string
    connection_draining_enabled     = bool
    connection_draining_timeout_sec = number
    pick_hostname                   = bool
  }))
  description = "(Required) The backend HTTP settings for the Application Gateway."
}

variable "http_listeners" {
  type = list(object({
    name                 = string
    frontend_port_number = string
    protocol             = string
    ssl_certificate_name = string
    host_name            = string
    require_sni          = bool
  }))
  description = "(Required) The HTTP listeners for the Application Gateway."
}

variable "probes" {
  type = list(object({
    name                  = string
    interval              = number
    timeout               = number
    protocol              = string
    path                  = string
    unhealthy_threshold   = number
    match_status_code     = list(string)
    pick_hostname_backend = bool
    host                  = string
  }))
  description = "(Required) The probes for the Application Gateway."
}

variable "request_routing_rules" {
  type = list(object({
    name                        = string
    priority                    = number
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    rule_type                   = string
    url_path_map_name           = string
    redirect_configuration_name = string
  }))
  description = "(Required) The request routing rules for the Application Gateway."
}

variable "waf_enabled" {
  type        = bool
  description = "(Required) Whether to enable the Web Application Firewall (WAF)."
}

variable "waf_mode" {
  type        = string
  description = "(Required) The mode of the WAF. Possible values: 'Detection' or 'Prevention'."
}

variable "sku_name" {
  type        = string
  description = "(Required) The name of the SKU to use for the Application Gateway."
}

variable "sku_tier" {
  type        = string
  description = "(Required) The tier of the SKU to use for the Application Gateway."
}

variable "capacity_min" {
  type        = number
  description = "(Required) The minimum capacity of the Application Gateway."
}

variable "capacity_max" {
  type        = number
  description = "(Required) The maximum capacity of the Application Gateway."
}
```
<!-- BEGIN_TF_DOCS -->
### main.tf

```hcl
terraform {
  backend "azurerm" {}

  required_providers {
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "0.2.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  resource_provider_registrations = "none"
}

provider "tls" {}
```

----------------------------

# Input Description

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.6 |  

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |  

## Modules

No modules.  

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_key_vault_access_policy.agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_network_interface.endpoint_backend_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.agw_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_role_assignment.agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appgw_public"></a> [appgw\_public](#input\_appgw\_public) | (Required) Indicate if the Application gateway should have private or public exposure | `bool` | `false` | no |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | n/a | <pre>list(object({<br/>    name  = string<br/>    fqdns = list(string)<br/>    ip    = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | n/a | <pre>list(object({<br/>    cookie_based_affinity           = string<br/>    name                            = string<br/>    path                            = string<br/>    port                            = number<br/>    protocol                        = string<br/>    request_timeout                 = number<br/>    host_name                       = string<br/>    probe_name                      = string<br/>    connection_draining_enabled     = bool<br/>    connection_draining_timeout_sec = number<br/>    pick_hostname                   = bool<br/>    trusted_root_certificate_names  = optional(list(string))<br/>  }))</pre> | n/a | yes |
| <a name="input_backend_pools_associate_nics"></a> [backend\_pools\_associate\_nics](#input\_backend\_pools\_associate\_nics) | (Optional) When you want to create a backend pool pointing directly to VM nics. Expects the backend pool with the `backend_name` property to already be created. The name of the map element should be the name of the backend. | `map(list(string))` | `{}` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | (Required) The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10 | `object({ min = number, max = number })` | n/a | yes |
| <a name="input_certificates_load_type"></a> [certificates\_load\_type](#input\_certificates\_load\_type) | (Optional) Upload method used for SSL and Trusted Root Certificates. Accepted values are Local or Keyvault. | `string` | `"Keyvault"` | no |
| <a name="input_certificates_path"></a> [certificates\_path](#input\_certificates\_path) | (Optional) Only if ssl\_certificates is set (not the ssl\_certificates\_keyvault) and certificates\_load\_type is set to Local. Path where are located the certificates (both authentication\_certificates and ssl certificates). Required if ssl\_certificates is set. | `string` | `""` | no |
| <a name="input_cipher_suites"></a> [cipher\_suites](#input\_cipher\_suites) | (Required) A List of accepted cipher suites.  Accepted values are: TLS\_RSA\_WITH\_AES\_128\_GCM\_SHA256, TLS\_RSA\_WITH\_AES\_256\_GCM\_SHA384, TLS\_DHE\_RSA\_WITH\_AES\_128\_GCM\_SHA256, TLS\_DHE\_RSA\_WITH\_AES\_256\_GCM\_SHA384, TLS\_ECDHE\_ECDSA\_WITH\_AES\_128\_GCM\_SHA256, TLS\_ECDHE\_ECDSA\_WITH\_AES\_256\_GCM\_SHA384, TLS\_ECDHE\_RSA\_WITH\_AES\_128\_GCM\_SHA256, TLS\_ECDHE\_RSA\_WITH\_AES\_256\_GCM\_SHA384 | `list(any)` | <pre>[<br/>  "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",<br/>  "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"<br/>]</pre> | no |
| <a name="input_create_backend_nic"></a> [create\_backend\_nic](#input\_create\_backend\_nic) | (Optional) Enable creation of a Network Interface Card for the Backend Address Pool Association. Accepted values are true or false | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | (Optional) The ID of the Web Application Firewall Policy. | `string` | `null` | no |
| <a name="input_frontend_port"></a> [frontend\_port](#input\_frontend\_port) | (Required) The frontend port used by the listener. | `list(string)` | n/a | yes |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | n/a | <pre>list(object({<br/>    name                 = string<br/>    host_name            = optional(string)<br/>    require_sni          = bool<br/>    ssl_certificate_name = optional(string)<br/>    protocol             = string<br/>    frontend_port_number = string<br/>  }))</pre> | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | (Required) The name of the key vault who store the certificate. | `string` | n/a | yes |
| <a name="input_key_vault_rbac"></a> [key\_vault\_rbac](#input\_key\_vault\_rbac) | extension tags | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) Specifies the supported Azure location where the resource exists. Changing this forces a new product to be created. | `string` | n/a | yes |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | (Optional) Required if there are backend\_address\_pools and create\_backend\_nic is set to true. A list of names of network Interfaces that should be created. IE: nic01, nic02, ... in a format of a list of strings. It Needs to be the same number of network\_interfaces as the number of backend\_address\_pools there are configured for the app gateway, and the same number of IPs in the private\_ip\_address\_nic\_association | `list(string)` | `[]` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | (Required) Not required only if frontend\_config\_private\_ip\_address\_allocation is set to Dynamic. The Private IP Address to use for the Application Gateway. | `string` | n/a | yes |
| <a name="input_private_ip_address_allocation"></a> [private\_ip\_address\_allocation](#input\_private\_ip\_address\_allocation) | (Optional) Required if there are backend\_address\_pools and create\_backend\_nic is set to true. The allocation method used for the Private IP Address in the NIC Association with the Backend Address Pool (only if necessary). Possible values are Dynamic and Static. If Static then private\_ip\_address\_nic\_association (list of Static IPs) needs to be configured | `string` | `"Static"` | no |
| <a name="input_private_ip_addresses_nic_association"></a> [private\_ip\_addresses\_nic\_association](#input\_private\_ip\_addresses\_nic\_association) | (Optional) Required if there are backend\_address\_pools and create\_backend\_nic is set to true. A list of static private IP addresses which should be used to associate NIC within the backend address pool. As many IP addresses as network\_interfaces and backend\_address\_pools there are. IMPORTANT: the IP addresses needs to be located in the subnet\_id, and needs to be different from the IPs configured within the app gateway (backend\_address\_pools) | `list(string)` | `[]` | no |
| <a name="input_probes"></a> [probes](#input\_probes) | n/a | <pre>list(object({<br/>    host                  = string<br/>    interval              = number<br/>    name                  = string<br/>    protocol              = string<br/>    path                  = string<br/>    timeout               = number<br/>    unhealthy_threshold   = number<br/>    match_status_code     = list(string)<br/>    pick_hostname_backend = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"project"` | no |
| <a name="input_redirect_configurations"></a> [redirect\_configurations](#input\_redirect\_configurations) | (Required) A list of redirections. | <pre>list(object({<br/>    name                 = string<br/>    redirect_type        = string<br/>    target_url           = string<br/>    include_path         = bool<br/>    include_query_string = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | n/a | <pre>list(object({<br/>    name                        = string<br/>    priority                    = number<br/>    http_listener_name          = string<br/>    backend_address_pool_name   = string<br/>    backend_http_settings_name  = string<br/>    url_path_map_name           = string<br/>    rule_type                   = string<br/>    redirect_configuration_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Product. | `string` | n/a | yes |
| <a name="input_rewrite_rule_sets"></a> [rewrite\_rule\_sets](#input\_rewrite\_rule\_sets) | n/a | <pre>list(object({<br/>    name = string<br/>    rewrite_rules = list(object({<br/>      name          = string<br/>      rule_sequence = string<br/>      conditions = list(object({<br/>        variable    = string<br/>        pattern     = string<br/>        ignore_case = bool<br/>        negate      = bool<br/>      }))<br/>      request_header_configurations = list(object({<br/>        header_name  = string<br/>        header_value = string<br/>      }))<br/>      response_header_configurations = list(object({<br/>        header_name  = string<br/>        header_value = string<br/>      }))<br/>      urls = list(object({<br/>        path         = string<br/>        query_string = string<br/>        reroute      = bool<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) The Name of the SKU to use for this Application Gateway. Accepted values are Standard\_v2 and WAF\_v2. Please refrain from using the WAF\_v2 mode (use only if necessary), instead use the Santander Imperva WAF. | `string` | `"Standard_v2"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | (Required) The Tier of the SKU to use for this Application Gateway. Accepted values are Standard\_v2 and WAF\_v2. Please refrain from using the WAF\_v2 mode (use only if necessary), instead use the Santander Imperva WAF. | `string` | `"Standard_v2"` | no |
| <a name="input_ssl_certificates_keyvault"></a> [ssl\_certificates\_keyvault](#input\_ssl\_certificates\_keyvault) | (Optional) Only if ssl\_certificates is not set and certificates\_load\_type is set to Keyvault. A list of ssl certificates with .pfx or .pem extension located in the keyvault as certificates (important: extract the secret id url from the **certificate**. Take note that it needs to be a Certificate, not a secret. This certificate in the keyvault has a Secret ID). It consists of a ==> name:The Name of the SSL certificate that is unique within this Application Gateway; key\_vault\_secret\_or\_certificate\_id: Secret ID of the Keyvault Certificate that has the .pfx or .pem file. | <pre>list(object({<br/>    name                               = string<br/>    key_vault_secret_or_certificate_id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_subnet_ids_nic_association"></a> [subnet\_ids\_nic\_association](#input\_subnet\_ids\_nic\_association) | (Optional) Required only if create\_backend\_nic is set to true. IDs of the subnets used for NIC association to the backend. | `list(string)` | `[]` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | (Required) The name of the Subnet within which the WAF will be connected. Needs to be different from the name of the subnet in the subnet\_id. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_trusted_root_certificates"></a> [trusted\_root\_certificates](#input\_trusted\_root\_certificates) | (Optional) List of objects taking the trusted root certificates in .crt extension for backend http settings | <pre>list(<br/>    object({<br/>      name        = string<br/>      certificate = string<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_url_path_map"></a> [url\_path\_map](#input\_url\_path\_map) | Maps directly to Application gateways's url\_path\_map. | <pre>list(object({<br/>    name = string<br/>    path_rule = list(<br/>      object({<br/>        name                        = string<br/>        paths                       = list(string)<br/>        backend_http_settings_name  = string<br/>        backend_address_pool_name   = string<br/>        redirect_configuration_name = string<br/>      })<br/>    )<br/>    redirect_setting = list(<br/>      object({<br/>        name                        = string<br/>        paths                       = list(string)<br/>        backend_http_settings_name  = string<br/>        backend_address_pool_name   = string<br/>        redirect_configuration_name = string<br/>      })<br/>    )<br/>    default_backend_address_pool_name   = string<br/>    backend_settings_name               = string<br/>    default_redirect_configuration_name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group that contains the virtual network. | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | (Required) The name of the Vnet within which the WAF will be connected. | `string` | n/a | yes |
| <a name="input_waf_disabled_rule_group"></a> [waf\_disabled\_rule\_group](#input\_waf\_disabled\_rule\_group) | (Optional) List of rules that will be removed of the waf | <pre>list(<br/>    object({<br/>      rule_group_name = string<br/>      rules           = list(string)<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_waf_enabled"></a> [waf\_enabled](#input\_waf\_enabled) | (Required) Is the Web Application Firewall be enabled? Allowed values: true or false. | `bool` | n/a | yes |
| <a name="input_waf_file_upload_limit_mb"></a> [waf\_file\_upload\_limit\_mb](#input\_waf\_file\_upload\_limit\_mb) | (Optional) Required if waf\_enabled is true. The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB. Defaults to 100MB. | `string` | `"100"` | no |
| <a name="input_waf_max_request_body_size_kb"></a> [waf\_max\_request\_body\_size\_kb](#input\_waf\_max\_request\_body\_size\_kb) | (Optional) Required if waf\_enabled is true. The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. Defaults to 128KB. | `string` | `"128"` | no |
| <a name="input_waf_mode"></a> [waf\_mode](#input\_waf\_mode) | (Required) The WAF mode, Prevention of Detection for test purposes. | `string` | `"Prevention"` | no |
| <a name="input_waf_rule_version"></a> [waf\_rule\_version](#input\_waf\_rule\_version) | (Optional) Required if waf\_enabled is true. The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, 3.1 and 3.2 | `string` | `"3.2"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A collection of availability zones to spread the Application Gateway over. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_gateway_id"></a> [application\_gateway\_id](#output\_application\_gateway\_id) | n/a |
<!-- END_TF_DOCS -->

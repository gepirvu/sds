# Infra Team Test

This template deploys a application SPI and is linked with ADO pipelines in `TIM-INFRA-MODULES` that references `azurerm_application_gateway` module for development testing.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |
| <a name="requirement_pkcs12"></a> [pkcs12](#requirement\_pkcs12) | 0.2.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.20.0 |
| <a name="provider_pkcs12"></a> [pkcs12](#provider\_pkcs12) | 0.2.5 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_appgwV2"></a> [appgwV2](#module\_appgwV2) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_application_gateway | ~{gitRef}~ |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_certificate.test](https://registry.terraform.io/providers/hashicorp/azurerm/4.20.0/docs/resources/key_vault_certificate) | resource |
| [pkcs12_from_pem.test](https://registry.terraform.io/providers/chilicat/pkcs12/0.2.5/docs/resources/from_pem) | resource |
| [tls_private_key.test](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.test](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.20.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/4.20.0/docs/data-sources/key_vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appgw_public"></a> [appgw\_public](#input\_appgw\_public) | Whether the Application Gateway should have public exposure. | `bool` | n/a | yes |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | (Required) The backend address pools for the Application Gateway. | <pre>list(object({<br/>    name  = string<br/>    ip    = list(string)<br/>    fqdns = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | (Required) The backend HTTP settings for the Application Gateway. | <pre>list(object({<br/>    cookie_based_affinity           = string<br/>    name                            = string<br/>    path                            = string<br/>    port                            = number<br/>    protocol                        = string<br/>    request_timeout                 = number<br/>    host_name                       = string<br/>    probe_name                      = string<br/>    connection_draining_enabled     = bool<br/>    connection_draining_timeout_sec = number<br/>    pick_hostname                   = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_capacity_max"></a> [capacity\_max](#input\_capacity\_max) | (Required) The maximum capacity of the Application Gateway. | `number` | n/a | yes |
| <a name="input_capacity_min"></a> [capacity\_min](#input\_capacity\_min) | (Required) The minimum capacity of the Application Gateway. | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_frontend_ip_private"></a> [frontend\_ip\_private](#input\_frontend\_ip\_private) | The private IP address for the Application Gateway frontend. | `string` | n/a | yes |
| <a name="input_frontend_port"></a> [frontend\_port](#input\_frontend\_port) | (Required) The frontend ports used by the listener. | `list(string)` | n/a | yes |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | (Required) The HTTP listeners for the Application Gateway. | <pre>list(object({<br/>    name                 = string<br/>    frontend_port_number = string<br/>    protocol             = string<br/>    ssl_certificate_name = string<br/>    host_name            = string<br/>    require_sni          = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | (Required) The name of the Key Vault in which to create the Application Gateway. | `string` | `"kv-test"` | no |
| <a name="input_key_vault_rbac"></a> [key\_vault\_rbac](#input\_key\_vault\_rbac) | Whether to enable RBAC for the Key Vault. | `bool` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The default location where the core network will be created | `string` | `"westeurope"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of WAF Or App GW to create. | `string` | `"test"` | no |
| <a name="input_probes"></a> [probes](#input\_probes) | (Required) The probes for the Application Gateway. | <pre>list(object({<br/>    name                  = string<br/>    interval              = number<br/>    timeout               = number<br/>    protocol              = string<br/>    path                  = string<br/>    unhealthy_threshold   = number<br/>    match_status_code     = list(string)<br/>    pick_hostname_backend = bool<br/>    host                  = string<br/>  }))</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS | `string` | `"prj"` | no |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | (Required) The request routing rules for the Application Gateway. | <pre>list(object({<br/>    name                        = string<br/>    priority                    = number<br/>    http_listener_name          = string<br/>    backend_address_pool_name   = string<br/>    backend_http_settings_name  = string<br/>    rule_type                   = string<br/>    url_path_map_name           = string<br/>    redirect_configuration_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Application Gateway. | `string` | `"rg-test"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) The name of the SKU to use for the Application Gateway. | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | (Required) The tier of the SKU to use for the Application Gateway. | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' for prod or 'np' for nonprod | `string` | `"np"` | no |
| <a name="input_vint_subnet_name"></a> [vint\_subnet\_name](#input\_vint\_subnet\_name) | n/a | `string` | `"Subnet name for Integrating in Webapps"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | (Required) The name of the virtual network in which to create the Application Gateway. | `string` | `"vnet-test"` | no |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | The name of the resource group that contains the virtual network. | `string` | n/a | yes |
| <a name="input_waf_enabled"></a> [waf\_enabled](#input\_waf\_enabled) | (Required) Whether to enable the Web Application Firewall (WAF). | `bool` | n/a | yes |
| <a name="input_waf_mode"></a> [waf\_mode](#input\_waf\_mode) | (Required) The mode of the WAF. Possible values: 'Detection' or 'Prevention'. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
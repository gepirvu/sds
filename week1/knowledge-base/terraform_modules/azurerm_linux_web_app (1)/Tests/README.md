# Infra Team Test

This template deploys a Resource Group a App Service Plan and then a linux app service

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_webapps"></a> [webapps](#module\_webapps) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_linux_web_app | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | (Optional)Azure COntainer Registry name | `string` | `null` | no |
| <a name="input_app_services"></a> [app\_services](#input\_app\_services) | Add details for your App services | <pre>list(object({<br/>    appservice_short_description         = string,<br/>    app_settings_name                    = string,<br/>    use_acr                              = bool, # If true give var.acr_name<br/>    acr_use_managed_identity_credentials = bool,<br/>    identity_type                        = string,<br/>    client_affinity_enabled              = bool,<br/>    worker_count                         = number,<br/>    ftps_state                           = string,<br/>    always_on                            = bool,<br/>    websockets_enabled                   = bool,<br/>    health_check_path                    = string,<br/>    health_check_eviction_time_in_min    = number,<br/>    vnet_route_all_enabled               = bool,<br/>    subnetname                           = string,<br/>    application_stack                    = string,<br/>    docker_image_name                    = string,<br/>    dotnet_version                       = string,<br/>    python_version                       = string<br/><br/>  }))</pre> | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | values for the app settings | `map(any)` | n/a | yes |
| <a name="input_default_documents"></a> [default\_documents](#input\_default\_documents) | Default documents to be added | `list(string)` | <pre>[<br/>  "Default.htm",<br/>  "Default.html",<br/>  "Default.asp",<br/>  "index.htm",<br/>  "index.html",<br/>  "iisstart.htm",<br/>  "default.aspx",<br/>  "index.php",<br/>  "hostingstart.html"<br/>]</pre> | no |
| <a name="input_deployment_slots"></a> [deployment\_slots](#input\_deployment\_slots) | Add details for your App services Slots | <pre>list(object({<br/>    deployment_slot_name                 = string,<br/>    appservice_short_description         = string,<br/>    client_affinity_enabled              = bool,<br/>    worker_count                         = number,<br/>    app_settings_name                    = string,<br/>    use_acr                              = bool, # If true give var.acr_name<br/>    acr_use_managed_identity_credentials = bool,<br/>    identity_type                        = string,<br/>    ftps_state                           = string,<br/>    always_on                            = bool,<br/>    websockets_enabled                   = bool,<br/>    health_check_path                    = string,<br/>    health_check_eviction_time_in_min    = number,<br/>    vnet_route_all_enabled               = bool,<br/>    subnetname                           = string,<br/>    application_stack                    = string,<br/>    docker_image_name                    = string,<br/>    dotnet_version                       = string,<br/>    python_version                       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_docker_registry_url"></a> [docker\_registry\_url](#input\_docker\_registry\_url) | (Optional)URL of the docker registry | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The short name for the environment. e.g. 'dev', 'qa', 'uat', 'prod' | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies azure region/location where resources will be created. | `string` | `"westeurope"` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The name of the resource group where the virtual network is created | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | n/a | `string` | `"Subnet name for the private endpoint"` | no |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | (Optional) The domain name for the custom private domain dns zone. | `string` | `"nonprod.cloudinfra.axpo.cloud"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The short name of the project e.g. 'mds' | `string` | n/a | yes |
| <a name="input_public_dns_zone_name"></a> [public\_dns\_zone\_name](#input\_public\_dns\_zone\_name) | (Optional) The domain name for the custom public domain dns zone. | `string` | `"cloudinfra.axpo.cloud"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the App Configuration. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_service_plan_os_type"></a> [service\_plan\_os\_type](#input\_service\_plan\_os\_type) | Type of the for the App Service Plan i.e Linux | `string` | `"Linux"` | no |
| <a name="input_service_plan_sku_name"></a> [service\_plan\_sku\_name](#input\_service\_plan\_sku\_name) | The SKU for the plan. Possible values include B1, I3, P1v2 | `string` | n/a | yes |
| <a name="input_service_plan_usage"></a> [service\_plan\_usage](#input\_service\_plan\_usage) | Short description to identify or diferentiate your App services plans | `string` | n/a | yes |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The short name of the subscription type e.g.  'p' or 'np' | `string` | n/a | yes |
| <a name="input_umid_names"></a> [umid\_names](#input\_umid\_names) | (Optional)List of User Assigned Managed Identity Names | `list(string)` | `[]` | no |
| <a name="input_vint_subnet_name"></a> [vint\_subnet\_name](#input\_vint\_subnet\_name) | n/a | `string` | `"Subnet name for Integrating in Webapps"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the virtual network for the Azure resources. | `string` | n/a | yes |
| <a name="input_webapp_custom_certificates"></a> [webapp\_custom\_certificates](#input\_webapp\_custom\_certificates) | (Optional) The list of Custom certificates to use in the web apps stored in the webapp\_custom\_certificates\_key\_vault. | <pre>map(object({<br/>    keyvault_certificate_name        = string<br/>    webapp_certificate_friendly_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_webapp_custom_certificates_key_vault"></a> [webapp\_custom\_certificates\_key\_vault](#input\_webapp\_custom\_certificates\_key\_vault) | (Optional) The name of the Key Vault where the custom certificates are stored. | `string` | `null` | no |
| <a name="input_webapp_custom_domains"></a> [webapp\_custom\_domains](#input\_webapp\_custom\_domains) | (Optional) The list of Custom domains to use in the web apps. | <pre>map(object({<br/>    webapp_description               = string<br/>    webapp_certificate_friendly_name = string<br/>    webapp_custom_domain_name        = string<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
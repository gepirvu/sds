# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.

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
| <a name="module_axso_container_registry"></a> [axso\_container\_registry](#module\_axso\_container\_registry) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_container_registry | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_allowed_subnets"></a> [acr\_allowed\_subnets](#input\_acr\_allowed\_subnets) | n/a | <pre>map(object({<br/>    subnet_name  = string<br/>    vnet_name    = string<br/>    vnet_rg_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_acr_umids"></a> [acr\_umids](#input\_acr\_umids) | n/a | <pre>list(object({<br/>    umid_name    = string<br/>    umid_rg_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | The admin enabled setting for the Azure Container Registry. | `bool` | `false` | no |
| <a name="input_allowed_ip_ranges"></a> [allowed\_ip\_ranges](#input\_allowed\_ip\_ranges) | List of IP addresses that are allowed to access the container registry. The IP address ranges in CIDR notation. e.g. | `list(string)` | <pre>[<br/>  "159.168.125.252/30",<br/>  "159.168.7.144/29",<br/>  "159.168.126.252/30"<br/>]</pre> | no |
| <a name="input_data_endpoint_enabled"></a> [data\_endpoint\_enabled](#input\_data\_endpoint\_enabled) | (Optional) Dedicated data endpoints enhance security by directing data connections through private IPs within your virtual network. Disabled endpoints expose data to the public internet, increasing the risk of interception or breaches. Enabling dedicated data endpoints strengthens your security posture. Defaults to true. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod"` | no |
| <a name="input_georeplications_configuration"></a> [georeplications\_configuration](#input\_georeplications\_configuration) | ACR must be on SKU 'Premium' to enable Geo-replication. Location must be different to primary location of ACR. | <pre>list(object({<br/>    location                = string<br/>    zone_redundancy_enabled = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of Managed Service Identity that should be configured on this App Configuration. | `string` | `"UserAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `"westeurope"` | no |
| <a name="input_pe_subnet"></a> [pe\_subnet](#input\_pe\_subnet) | n/a | <pre>object({<br/>    subnet_name  = string<br/>    vnet_name    = string<br/>    vnet_rg_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Specifies whether or not public network access is allowed for the container registry. Defaults to false. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_retention_policy_in_days"></a> [retention\_policy\_in\_days](#input\_retention\_policy\_in\_days) | (Optional) This policy checks if the retention policy is enabled for Azure Container Registry, ensuring that untagged manifests are automatically deleted.. Defaults to 7 days. | `number` | `7` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
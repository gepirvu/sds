# Infra Team Test

This is a test for the Infra team to check the quality of the code and the documentation.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.20.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apim"></a> [apim](#module\_apim) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_api_management | ~{gitRef}~ |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.network_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/4.20.0/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association.subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/4.20.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/4.20.0/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_insights_name"></a> [app\_insights\_name](#input\_app\_insights\_name) | (Optional)In case you want to integrate APIM with application insights please specify name | `string` | `null` | no |
| <a name="input_backend_protocol"></a> [backend\_protocol](#input\_backend\_protocol) | Protocol for the backend http or soap | `string` | `"http"` | no |
| <a name="input_backend_services"></a> [backend\_services](#input\_backend\_services) | (Optional)Include backend setting in case are needed | `list(string)` | `[]` | no |
| <a name="input_developer_portal_host_name"></a> [developer\_portal\_host\_name](#input\_developer\_portal\_host\_name) | (Optional)Name for the developers portal URL | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"dev"` | no |
| <a name="input_gateway_host_name"></a> [gateway\_host\_name](#input\_gateway\_host\_name) | (Optional)Name for the gateway URL | `string` | `null` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the Key Vault where the secrets are read | `string` | `null` | no |
| <a name="input_keyvault_named_values"></a> [keyvault\_named\_values](#input\_keyvault\_named\_values) | (Optional)Map containing the name of the named values as key and value as values. The secret is stored in keyvault | `list(map(string))` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The default location where the resource will be created | `string` | `"westeurope"` | no |
| <a name="input_management_host_name"></a> [management\_host\_name](#input\_management\_host\_name) | (Optional)Name for the management portal URL | `string` | `null` | no |
| <a name="input_named_values"></a> [named\_values](#input\_named\_values) | (Optional)Map containing the name of the named values as key and value as values | `list(map(string))` | `[]` | no |
| <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name) | The name of the network security group. | `string` | n/a | yes |
| <a name="input_publisher_email"></a> [publisher\_email](#input\_publisher\_email) | The email of publisher/company. | `string` | `"mario.martinezdiez@axpo.com"` | no |
| <a name="input_publisher_name"></a> [publisher\_name](#input\_publisher\_name) | The name of publisher/company. | `string` | `null` | no |
| <a name="input_requires_custom_host_name_configuration"></a> [requires\_custom\_host\_name\_configuration](#input\_requires\_custom\_host\_name\_configuration) | If APIM requires custom hostname configuration | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer, Basic, Standard and Premium. The second part is the capacity | `string` | `"Basic_1"` | no |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | The name of the subnet for the Azure resources. | `list(string)` | n/a | yes |
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
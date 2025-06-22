# Infra Team Test

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 3.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.20.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_axso_dashboard_grafana"></a> [axso\_dashboard\_grafana](#module\_axso\_dashboard\_grafana) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_dashboard_grafana | ~{gitRef}~ |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_groups"></a> [admin\_groups](#input\_admin\_groups) | The list of admin groups for the Grafana instance. | `list(string)` | `[]` | no |
| <a name="input_api_key_enabled"></a> [api\_key\_enabled](#input\_api\_key\_enabled) | Indicates whether the API key should be enabled for the Grafana instance. | `bool` | `false` | no |
| <a name="input_azure_monitor_workspace_enabled"></a> [azure\_monitor\_workspace\_enabled](#input\_azure\_monitor\_workspace\_enabled) | Indicates whether the Azure Monitor Workspace should be enabled for the Grafana instance. | `bool` | `true` | no |
| <a name="input_deterministic_outbound_ip_enabled"></a> [deterministic\_outbound\_ip\_enabled](#input\_deterministic\_outbound\_ip\_enabled) | Indicates whether the deterministic outbound IP should be enabled for the Grafana instance. Only use it in case you cant use private connection to the datasources. | `bool` | `false` | no |
| <a name="input_editor_groups"></a> [editor\_groups](#input\_editor\_groups) | The list of editor groups for the Grafana instance. | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment. e.g. dev, qa, uat, prod | `string` | `"prod "` | no |
| <a name="input_grafana_major_version"></a> [grafana\_major\_version](#input\_grafana\_major\_version) | The major version of Grafana to use. Possible values are 9 and 10. | `string` | `"10"` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The identity type for the Grafana instance. Possible values are SystemAssigned and UserAssigned. UserAssigned is not supported yet. | `string` | `"SystemAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location where the Managed Kubernetes Cluster should be created. Changing this forces a new resource to be created. | `string` | `"west europe"` | no |
| <a name="input_monitor_workspace_public_network_access_enabled"></a> [monitor\_workspace\_public\_network\_access\_enabled](#input\_monitor\_workspace\_public\_network\_access\_enabled) | Indicates whether the public network access should be enabled for the Azure Monitor Workspace. | `bool` | `false` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The existing core network resource group name, to get details of the VNET to enable  private endpoint. | `string` | n/a | yes |
| <a name="input_pe_subnet_name"></a> [pe\_subnet\_name](#input\_pe\_subnet\_name) | The subnet name, used in data source to get subnet ID, to enable the private endpoint. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project. e.g. MDS, etools, cp, cpm etc.. etc.. | `string` | `"etools"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | `string` | `"axso-np-appl-<project-name>-<environment>-rg"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of the Grafana instance. Possible values are Essential and Standard. | `string` | `"Standard"` | no |
| <a name="input_smtp_enable"></a> [smtp\_enable](#input\_smtp\_enable) | Indicates whether the SMTP should be enabled for the Grafana instance. | `bool` | `false` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | The subscription type e.g. 'p' or 'np' | `string` | `"p"` | no |
| <a name="input_viewer_groups"></a> [viewer\_groups](#input\_viewer\_groups) | The list of viewer groups for the Grafana instance. | `list(string)` | `[]` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Virtual network name for the enviornment to enable private endpoint. | `string` | n/a | yes |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Indicates whether zone redundancy should be enabled for the Grafana instance. | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
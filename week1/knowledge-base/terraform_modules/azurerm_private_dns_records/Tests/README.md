# Infra Team Test

This template deploys Azure Private DNS records and is linked with ADO pipelines in `TIM-INFRA-MODULES` for development testing.

The `Private DNS Zones` will then be configured with all possible options for private DNS record types: `A`, `AAAA`, `CNAME`, `MX`, `PTR`, `SRV` and `TXT` as per the variables configured in `module.tf.tfvars`.  

Note that not all record types are required to be specified in the usage of this module, this example shows all types.  
You only need to specify the record types you want to create/Administer.  
The `module.tf.tfvars` file in this test is used to pass in the required variables to the module to be tested for all possible record types.  

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 4.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns-a-records-administration-test"></a> [dns-a-records-administration-test](#module\_dns-a-records-administration-test) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records | ~{gitRef}~ |
| <a name="module_dns-cname-records-administration-test"></a> [dns-cname-records-administration-test](#module\_dns-cname-records-administration-test) | git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records | ~{gitRef}~ |

## Resources

| Name | Type |
|------|------|
| [random_integer.number](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_a_records"></a> [dns\_a\_records](#input\_dns\_a\_records) | Specifies values of A records to create across multiple zones, each 'record\_no' has to be unique. | <pre>list(object({<br>    zone_name           = string<br>    resource_group_name = string<br>    record_no           = number<br>    record_type         = string<br>    record_name         = string<br>    ttl                 = number<br>    record_value        = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "record_name": "testA1",<br>    "record_no": 1,<br>    "record_type": "A",<br>    "record_value": [<br>      "10.0.1.10"<br>    ],<br>    "resource_group_name": "rg-where-private-dns-zone-is-located",<br>    "ttl": 300,<br>    "zone_name": "axso.zone.local"<br>  }<br>]</pre> | no |
| <a name="input_dns_cname_records"></a> [dns\_cname\_records](#input\_dns\_cname\_records) | Specifies values of CNAME records to create across multiple zones, each 'record\_no' has to be unique. | <pre>list(object({<br>    zone_name           = string<br>    resource_group_name = string<br>    record_no           = number<br>    record_type         = string<br>    record_name         = string<br>    ttl                 = number<br>    record_value        = string<br>  }))</pre> | <pre>[<br>  {<br>    "record_name": "msservice1",<br>    "record_no": 1,<br>    "record_type": "CNAME",<br>    "record_value": "contoso.com",<br>    "resource_group_name": "rg-where-private-dns-zone-is-located",<br>    "ttl": 300,<br>    "zone_name": "axso.zone.local"<br>  }<br>]</pre> | no |
| <a name="input_dns_sub_id"></a> [dns\_sub\_id](#input\_dns\_sub\_id) | The id of the HUB subcription where the private dns zone is deployed | `string` | `"36cae50e-ce2a-438f-bd97-216b7f682c77"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
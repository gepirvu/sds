
resource "random_integer" "number" {
  min = 0001
  max = 9999
}

##########################################
# MODULE                                 #
##########################################
# Administer A records example
module "dns-a-records-administration-test" {
  providers = {
    azurerm = azurerm.dns
  }
  for_each                 = { for each in var.dns_a_records : "${each.record_type}-${each.record_no}" => each }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=~{gitRef}~"
  private_dns_zone_name    = each.value.zone_name
  resource_group_name      = each.value.resource_group_name
  private_dns_record_type  = each.value.record_type
  private_dns_record_ttl   = each.value.ttl
  private_dns_record_name  = each.value.record_name
  private_dns_record_value = each.value.record_value
}

# Administer CNAME records example
module "dns-cname-records-administration-test" {
  providers = {
    azurerm = azurerm.dns
  }
  for_each                 = { for each in var.dns_cname_records : "${each.record_type}-${each.record_no}" => each }
  source                   = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_private_dns_records?ref=~{gitRef}~"
  private_dns_zone_name    = each.value.zone_name
  resource_group_name      = each.value.resource_group_name
  private_dns_record_type  = each.value.record_type
  private_dns_record_ttl   = each.value.ttl
  private_dns_record_name  = each.value.record_name
  private_dns_record_value = each.value.record_value
}

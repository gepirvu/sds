#Zones
variable "dns_sub_id" {
  type        = string
  description = "The id of the HUB subcription where the private dns zone is deployed"
  default     = "36cae50e-ce2a-438f-bd97-216b7f682c77"
}

### DNS configuration variables (Not all of these are needed, only the ones you want to use)
# A records example var #
variable "dns_a_records" {
  type = list(object({
    zone_name           = string
    resource_group_name = string
    record_no           = number
    record_type         = string
    record_name         = string
    ttl                 = number
    record_value        = list(string)
  }))
  default = [{
    record_no           = 1
    zone_name           = "axso.zone.local"
    resource_group_name = "rg-where-private-dns-zone-is-located"
    record_type         = "A"
    record_name         = "testA1"
    ttl                 = 300
    record_value        = ["10.0.1.10"]
  }]
  description = "Specifies values of A records to create across multiple zones, each 'record_no' has to be unique."
}

# CNAME records example var #
variable "dns_cname_records" {
  type = list(object({
    zone_name           = string
    resource_group_name = string
    record_no           = number
    record_type         = string
    record_name         = string
    ttl                 = number
    record_value        = string
  }))
  default = [{
    record_no           = 1
    zone_name           = "axso.zone.local"
    resource_group_name = "rg-where-private-dns-zone-is-located"
    record_type         = "CNAME"
    record_name         = "msservice1"
    ttl                 = 300
    record_value        = "contoso.com"
  }]
  description = "Specifies values of CNAME records to create across multiple zones, each 'record_no' has to be unique."
}

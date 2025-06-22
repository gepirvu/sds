# A records Administration example
dns_sub_id = "36cae50e-ce2a-438f-bd97-216b7f682c77"

dns_a_records = [
  {
    record_no           = 1
    zone_name           = "westeurope.azurecontainerapps.io"
    resource_group_name = "rg-privatedns-pe-prod-axpo"
    record_type         = "A"
    record_name         = "TEST-A"
    ttl                 = 300
    record_value        = ["10.0.1.10"]
  }
]

# CNAME records Administration example
dns_cname_records = [
  {
    record_no           = 1
    zone_name           = "westeurope.azurecontainerapps.io"
    resource_group_name = "rg-privatedns-pe-prod-axpo"
    record_type         = "CNAME"
    record_name         = "testCNAME"
    ttl                 = 300
    record_value        = "contoso.com"
  }
]

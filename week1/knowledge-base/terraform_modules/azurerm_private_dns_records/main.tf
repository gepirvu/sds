# Create Private DNS records based on type variable value (A, AAAA, CNAME, MX, PTR, SRV, TXT)
resource "azurerm_private_dns_a_record" "private_dns_a_record" {
  count               = var.private_dns_record_type == "A" ? 1 : 0
  name                = lower(var.private_dns_record_name)
  resource_group_name = var.resource_group_name
  ttl                 = var.private_dns_record_ttl
  zone_name           = var.private_dns_zone_name
  records             = var.private_dns_record_value
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_aaaa_record" "private_dns_aaaa_record" {
  count               = var.private_dns_record_type == "AAAA" ? 1 : 0
  name                = lower(var.private_dns_record_name)
  resource_group_name = var.resource_group_name
  ttl                 = var.private_dns_record_ttl
  zone_name           = var.private_dns_zone_name
  records             = var.private_dns_record_value
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_cname_record" "private_dns_cname_record" {
  count               = var.private_dns_record_type == "CNAME" ? 1 : 0
  name                = lower(var.private_dns_record_name)
  resource_group_name = var.resource_group_name
  ttl                 = var.private_dns_record_ttl
  zone_name           = var.private_dns_zone_name
  record              = var.private_dns_record_value
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_mx_record" "private_dns_mx_record" {
  count               = var.private_dns_record_type == "MX" ? 1 : 0
  name                = lower(var.private_dns_record_name)
  resource_group_name = var.resource_group_name
  ttl                 = var.private_dns_record_ttl
  zone_name           = var.private_dns_zone_name
  dynamic "record" {
    for_each = var.private_dns_record_value
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_ptr_record" "private_dns_ptr_record" {
  count               = var.private_dns_record_type == "PTR" ? 1 : 0
  name                = lower(var.private_dns_record_name)
  resource_group_name = var.resource_group_name
  ttl                 = var.private_dns_record_ttl
  zone_name           = var.private_dns_zone_name
  records             = var.private_dns_record_value
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_srv_record" "private_dns_srv_record" {
  count               = var.private_dns_record_type == "SRV" ? 1 : 0
  name                = lower(var.private_dns_record_name)
  resource_group_name = var.resource_group_name
  ttl                 = var.private_dns_record_ttl
  zone_name           = var.private_dns_zone_name
  dynamic "record" {
    for_each = var.private_dns_record_value
    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_txt_record" "private_dns_txt_record" {
  count               = var.private_dns_record_type == "TXT" ? 1 : 0
  name                = lower(var.private_dns_record_name)
  resource_group_name = var.resource_group_name
  ttl                 = var.private_dns_record_ttl
  zone_name           = var.private_dns_zone_name
  dynamic "record" {
    for_each = var.private_dns_record_value
    content {
      value = record.value
    }
  }
  lifecycle {
    ignore_changes = [tags]
  }
}
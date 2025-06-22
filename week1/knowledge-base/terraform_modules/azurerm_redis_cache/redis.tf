#-------------------------------------------------------------------------------------------------------------------#
# Redis                                                                                                             #
#-------------------------------------------------------------------------------------------------------------------#

resource "azurerm_redis_cache" "redis_cache" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = local.redis_cache_name

  # Pricing
  capacity = var.capacity
  family   = var.family
  sku_name = var.sku_name

  # Network
  public_network_access_enabled = var.public_network_access_enabled

  # Authentication
  access_keys_authentication_enabled = var.access_keys_authentication_enabled

  # Security
  non_ssl_port_enabled = var.non_ssl_port_enabled
  minimum_tls_version  = var.minimum_tls_version

  # Patching - The Patch Window lasts for 5 hours from the start_hour_utc.
  dynamic "patch_schedule" {
    for_each = var.enable_patching ? [1] : []

    content {
      day_of_week    = var.day_of_week
      start_hour_utc = var.start_hour_utc
    }
  }

  # Authentication
  dynamic "identity" {
    for_each = var.identity_type != null ? toset([1]) : toset([])

    content {
      type         = can(regex("SystemAssigned", var.identity_type)) ? "SystemAssigned" : can(regex("UserAssigned", var.identity_type)) ? "UserAssigned" : null
      identity_ids = can(regex("UserAssigned", var.identity_type)) ? values(data.azurerm_user_assigned_identity.umids)[*].id : null
    }
  }

  # Advanced
  redis_configuration {
    active_directory_authentication_enabled = var.sku_name == "Premium" ? var.active_directory_authentication_enabled : null
  }

  replicas_per_master  = var.sku_name == "Premium" ? 1 : null
  replicas_per_primary = var.sku_name == "Premium" ? 1 : null

  lifecycle {
    ignore_changes = [tags]
  }

}

#-------------------------------------------------------------------------------------------------------------------#
# Redis cache - Private endpoint                                                                                    #
#-------------------------------------------------------------------------------------------------------------------#

resource "azurerm_redis_firewall_rule" "fw_rules" {
  for_each            = var.redis_fw_rules != null && length(var.redis_fw_rules) > 0 ? var.redis_fw_rules : {}
  name                = each.value.name
  redis_cache_name    = azurerm_redis_cache.redis_cache.name
  resource_group_name = azurerm_redis_cache.redis_cache.resource_group_name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}

#-------------------------------------------------------------------------------------------------------------------#
# Redis cache - Private endpoint                                                                                    #
#-------------------------------------------------------------------------------------------------------------------#

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${azurerm_redis_cache.redis_cache.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet[0].id

  private_service_connection {
    name                           = "${azurerm_redis_cache.redis_cache.name}-pe-sc"
    private_connection_resource_id = azurerm_redis_cache.redis_cache.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = "privatelink.redis.cache.windows.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [azurerm_redis_cache.redis_cache]
}

#-------------------------------------------------------------------------------------------------------------------#
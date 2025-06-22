locals {
  redis_cache_name    = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-redis-cache")
  private_dns_zone_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.redis.cache.windows.net"
} 
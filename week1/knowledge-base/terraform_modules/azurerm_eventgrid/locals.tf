
locals {

  private_dns_zone_id         = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.eventgrid.azure.net"
  eventgrid_domain_name       = "axso-${var.subscription}-appl-${var.project_name}-${var.environment}-egd"
  eventgrid_subscription_name = "axso-${var.subscription}-appl-${var.project_name}-${var.environment}-egs"

  topics = flatten([for parent_domain in var.eventgrid_domain_config : [
    for child_topic in parent_domain.topics : {
      parent_domain = parent_domain.eventgrid_domain_purpose
      topic_name    = child_topic.topic_name
    }
  ]])

  webhook_subscriptions = flatten([for parent_domain in var.eventgrid_domain_config : [
    for child_topic in parent_domain.topics : [
      for child_subscription in child_topic.subscriptions : {
        parent_domain     = parent_domain.eventgrid_domain_purpose
        topic_name        = child_topic.topic_name
        subscription_name = child_subscription.webhooks
      }
  ]]])

  storage_queue_subscriptions = flatten([for parent_domain in var.eventgrid_domain_config : [
    for child_topic in parent_domain.topics : [
      for child_subscription in child_topic.subscriptions : {
        parent_domain     = parent_domain.eventgrid_domain_purpose
        topic_name        = child_topic.topic_name
        subscription_name = child_subscription.storage_queues
      }
  ]]])

}

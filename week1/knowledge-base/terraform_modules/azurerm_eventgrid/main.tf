
resource "azurerm_eventgrid_domain" "eventgrid_domains" {

  for_each = {
    for index, value in var.eventgrid_domain_config :
    value.eventgrid_domain_purpose => value
  }

  name                          = "${local.eventgrid_domain_name}-${each.value.eventgrid_domain_purpose}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  input_schema                  = each.value.event_schema
  local_auth_enabled            = false
  public_network_access_enabled = false

  dynamic "identity" {
    for_each = each.value.system_assigned_identity ? ["enabled"] : []
    content {
      type = "SystemAssigned"
    }
  }
}

resource "azurerm_private_endpoint" "eventgrid_domains_pe" {
  depends_on = [azurerm_eventgrid_domain.eventgrid_domains]

  for_each = {
    for index, value in var.eventgrid_domain_config :
    value.eventgrid_domain_purpose => value
  }

  name                = "${azurerm_eventgrid_domain.eventgrid_domains[each.value.eventgrid_domain_purpose].name}-pe"
  resource_group_name = var.virtual_network_resource_group_name
  location            = var.location
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "${azurerm_eventgrid_domain.eventgrid_domains[each.value.eventgrid_domain_purpose].name}-pe-egd"
    private_connection_resource_id = azurerm_eventgrid_domain.eventgrid_domains[each.value.eventgrid_domain_purpose].id
    is_manual_connection           = false
    subresource_names              = ["domain"]
  }

  private_dns_zone_group {
    name                 = "privatelink.eventgrid.azure.net"
    private_dns_zone_ids = [local.private_dns_zone_id]
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_eventgrid_domain_topic" "eventgrid_domain_topics" {
  depends_on = [azurerm_eventgrid_domain.eventgrid_domains]

  for_each = { for index, value in local.topics : "${value.parent_domain}-${value.topic_name}" => value }

  name                = each.value.topic_name
  domain_name         = "${local.eventgrid_domain_name}-${each.value.parent_domain}"
  resource_group_name = var.resource_group_name
}

resource "azurerm_eventgrid_event_subscription" "webhook_subscriptions" {
  depends_on = [azurerm_eventgrid_domain_topic.eventgrid_domain_topics]

  for_each = { for index, value in local.webhook_subscriptions : "${value.parent_domain}-${value.topic_name}" => value }

  name                  = "${local.eventgrid_subscription_name}-${each.value.subscription_name}"
  scope                 = each.value.scope
  event_delivery_schema = each.value.event_schema

  webhook_endpoint {
    url                               = each.value.eventgrid_webhook_endpoint
    max_events_per_batch              = each.value.eventgrid_webhook_max_events_per_batch
    preferred_batch_size_in_kilobytes = each.value.eventgrid_webhook_preferred_batch_size_in_kilobytes
    active_directory_tenant_id        = each.value.eventgrid_webhook_active_directory_tenant_id
    active_directory_app_id_or_uri    = each.value.eventgrid_webhook_active_directory_app_id_or_uri

  }
  dynamic "storage_blob_dead_letter_destination" {
    for_each = each.value.webhooks.dead_letter_storage_account_id != null ? ["enable"] : []
    content {
      storage_account_id          = each.value.webhooks.dead_letter_storage_account_id
      storage_blob_container_name = each.value.webhooks.dead_letter_storage_blob_container_name
    }
  }

  dynamic "dead_letter_identity" {
    for_each = each.value.webhooks.dead_letter_identity != null && each.value.webhooks.dead_letter_user_assigned_identity == null ? ["enable"] : []
    content {
      type = each.value.webhooks.dead_letter_identity_type
    }
  }

  dynamic "dead_letter_identity" {
    for_each = each.value.webhooks.dead_letter_identity != null && each.value.webhooks.dead_letter_user_assigned_identity != null ? ["enable"] : []
    content {
      type                   = each.value.webhooks.dead_letter_identity_type
      user_assigned_identity = each.value.webhooks.dead_letter_user_assigned_identity
    }
  }

  dynamic "subject_filter" {
    for_each = each.value.webhooks.subject_filters
    content {
      subject_begins_with = subject_filter.value.subject_begins_with
      subject_ends_with   = subject_filter.value.subject_ends_with
      case_sensitive      = subject_filter.value.case_sensitive
    }
  }

  dynamic "advanced_filter" {
    for_each = each.value.webhooks.advanced_filters
    content {
      dynamic "bool_equals" {
        for_each = advanced_filter.value.bool_equals
        content {
          key   = bool_equals.value.key
          value = bool_equals.value.value
        }
      }
      dynamic "number_greater_than" {
        for_each = advanced_filter.value.number_greater_than
        content {
          key   = number_greater_than.value.key
          value = number_greater_than.value.value
        }
      }
      dynamic "number_greater_than_or_equals" {
        for_each = advanced_filter.value.number_greater_than_or_equals
        content {
          key   = number_greater_than_or_equals.value.key
          value = number_greater_than_or_equals.value.value
        }
      }
      dynamic "number_less_than" {
        for_each = advanced_filter.value.number_less_than
        content {
          key   = number_less_than.value.key
          value = number_less_than.value.value
        }
      }
      dynamic "number_less_than_or_equals" {
        for_each = advanced_filter.value.number_less_than_or_equals
        content {
          key   = number_less_than_or_equals.value.key
          value = number_less_than_or_equals.value.value
        }
      }
      dynamic "number_in" {
        for_each = advanced_filter.value.number_in
        content {
          key    = number_in.value.key
          values = number_in.value.values
        }
      }
      dynamic "number_in_range" {
        for_each = advanced_filter.value.number_in_range
        content {
          key    = number_in_range.value.key
          values = number_in_range.value.values
        }
      }
      dynamic "number_not_in_range" {
        for_each = advanced_filter.value.number_not_in_range
        content {
          key    = number_not_in_range.value.key
          values = number_not_in_range.value.values
        }
      }

      dynamic "string_begins_with" {
        for_each = advanced_filter.value.string_begins_with
        content {
          key    = string_begins_with.value.key
          values = string_begins_with.value.values
        }
      }
      dynamic "string_not_begins_with" {
        for_each = advanced_filter.value.bostring_not_begins_withol_equals
        content {
          key    = string_not_begins_with.value.key
          values = string_not_begins_with.value.values
        }
      }
      dynamic "string_ends_with" {
        for_each = advanced_filter.value.string_ends_with
        content {
          key    = string_ends_with.value.key
          values = string_ends_with.value.values
        }
      }
      dynamic "string_not_ends_with" {
        for_each = advanced_filter.value.bool_eqstring_not_ends_withuals
        content {
          key    = string_not_ends_with.value.key
          values = string_not_ends_with.value.values
        }
      }
      dynamic "string_contains" {
        for_each = advanced_filter.value.string_contains
        content {
          key    = string_contains.value.key
          values = string_contains.value.values
        }
      }
      dynamic "string_not_contains" {
        for_each = advanced_filter.value.string_not_contains
        content {
          key    = string_not_contains.value.key
          values = string_not_contains.value.values
        }
      }
      dynamic "string_in" {
        for_each = advanced_filter.value.string_in
        content {
          key    = string_in.value.key
          values = string_in.value.values
        }
      }
      dynamic "string_not_in" {
        for_each = advanced_filter.value.string_not_in
        content {
          key    = string_not_in.value.key
          values = string_not_in.value.values
        }
      }
      dynamic "is_not_null" {
        for_each = advanced_filter.value.is_not_null
        content {
          key = is_not_null.value.key
        }
      }
      dynamic "is_null_or_undefined" {
        for_each = advanced_filter.value.is_null_or_undefined
        content {
          key = is_null_or_undefined.value.key
        }
      }
    }
  }

}

resource "azurerm_eventgrid_event_subscription" "storage_queue_subscriptions" {
  depends_on = [azurerm_eventgrid_domain_topic.eventgrid_domain_topics]

  for_each = { for index, value in local.storage_queue_subscriptions : "${value.parent_domain}-${value.topic_name}" => value }

  name                  = each.value.subscription_name
  scope                 = each.value.scope
  event_delivery_schema = each.value.event_schema

  storage_queue_endpoint {
    storage_account_id                    = each.value.storage_account_id
    queue_name                            = each.value.queue_name
    queue_message_time_to_live_in_seconds = each.value.queue_message_time_to_live_in_seconds

  }

  dynamic "storage_blob_dead_letter_destination" {
    for_each = each.value.webhooks.dead_letter_storage_account_id != null ? ["enable"] : []
    content {
      storage_account_id          = each.value.webhooks.dead_letter_storage_account_id
      storage_blob_container_name = each.value.webhooks.dead_letter_storage_blob_container_name
    }
  }

  dynamic "dead_letter_identity" {
    for_each = each.value.webhooks.dead_letter_identity != null && each.value.webhooks.dead_letter_user_assigned_identity == null ? ["enable"] : []
    content {
      type = each.value.webhooks.dead_letter_identity_type
    }
  }

  dynamic "dead_letter_identity" {
    for_each = each.value.webhooks.dead_letter_identity != null && each.value.webhooks.dead_letter_user_assigned_identity != null ? ["enable"] : []
    content {
      type                   = each.value.webhooks.dead_letter_identity_type
      user_assigned_identity = each.value.webhooks.dead_letter_user_assigned_identity
    }
  }

  dynamic "subject_filter" {
    for_each = each.value.storage_queues.subject_filters
    content {
      subject_begins_with = subject_filter.value.subject_begins_with
      subject_ends_with   = subject_filter.value.subject_ends_with
      case_sensitive      = subject_filter.value.case_sensitive
    }
  }

  dynamic "advanced_filter" {
    for_each = each.value.storage_queues.advanced_filters
    content {
      dynamic "bool_equals" {
        for_each = advanced_filter.value.bool_equals
        content {
          key   = bool_equals.value.key
          value = bool_equals.value.value
        }
      }
      dynamic "number_greater_than" {
        for_each = advanced_filter.value.number_greater_than
        content {
          key   = number_greater_than.value.key
          value = number_greater_than.value.value
        }
      }
      dynamic "number_greater_than_or_equals" {
        for_each = advanced_filter.value.number_greater_than_or_equals
        content {
          key   = number_greater_than_or_equals.value.key
          value = number_greater_than_or_equals.value.value
        }
      }
      dynamic "number_less_than" {
        for_each = advanced_filter.value.number_less_than
        content {
          key   = number_less_than.value.key
          value = number_less_than.value.value
        }
      }
      dynamic "number_less_than_or_equals" {
        for_each = advanced_filter.value.number_less_than_or_equals
        content {
          key   = number_less_than_or_equals.value.key
          value = number_less_than_or_equals.value.value
        }
      }
      dynamic "number_in" {
        for_each = advanced_filter.value.number_in
        content {
          key    = number_in.value.key
          values = number_in.value.values
        }
      }
      dynamic "number_in_range" {
        for_each = advanced_filter.value.number_in_range
        content {
          key    = number_in_range.value.key
          values = number_in_range.value.values
        }
      }
      dynamic "number_not_in_range" {
        for_each = advanced_filter.value.number_not_in_range
        content {
          key    = number_not_in_range.value.key
          values = number_not_in_range.value.values
        }
      }

      dynamic "string_begins_with" {
        for_each = advanced_filter.value.string_begins_with
        content {
          key    = string_begins_with.value.key
          values = string_begins_with.value.values
        }
      }
      dynamic "string_not_begins_with" {
        for_each = advanced_filter.value.bostring_not_begins_withol_equals
        content {
          key    = string_not_begins_with.value.key
          values = string_not_begins_with.value.values
        }
      }
      dynamic "string_ends_with" {
        for_each = advanced_filter.value.string_ends_with
        content {
          key    = string_ends_with.value.key
          values = string_ends_with.value.values
        }
      }
      dynamic "string_not_ends_with" {
        for_each = advanced_filter.value.bool_eqstring_not_ends_withuals
        content {
          key    = string_not_ends_with.value.key
          values = string_not_ends_with.value.values
        }
      }
      dynamic "string_contains" {
        for_each = advanced_filter.value.string_contains
        content {
          key    = string_contains.value.key
          values = string_contains.value.values
        }
      }
      dynamic "string_not_contains" {
        for_each = advanced_filter.value.string_not_contains
        content {
          key    = string_not_contains.value.key
          values = string_not_contains.value.values
        }
      }
      dynamic "string_in" {
        for_each = advanced_filter.value.string_in
        content {
          key    = string_in.value.key
          values = string_in.value.values
        }
      }
      dynamic "string_not_in" {
        for_each = advanced_filter.value.string_not_in
        content {
          key    = string_not_in.value.key
          values = string_not_in.value.values
        }
      }
      dynamic "is_not_null" {
        for_each = advanced_filter.value.is_not_null
        content {
          key = is_not_null.value.key
        }
      }
      dynamic "is_null_or_undefined" {
        for_each = advanced_filter.value.is_null_or_undefined
        content {
          key = is_null_or_undefined.value.key
        }
      }
    }
  }
}

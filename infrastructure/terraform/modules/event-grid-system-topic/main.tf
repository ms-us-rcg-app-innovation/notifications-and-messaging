resource "azurerm_eventgrid_system_topic" "eg_system_topic" {
  name                   = var.topic_name
  topic_type             = var.topic_type
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_arm_resource_id = var.event_source_id
}

resource "azurerm_eventgrid_system_topic_event_subscription" "event_subscription_with_queue_endpoint" {
  for_each                      = var.subscriptions_with_queue_endpoint
  name                          = each.key
  system_topic                  = azurerm_eventgrid_system_topic.eg_system_topic.name
  resource_group_name           = var.resource_group_name
  service_bus_queue_endpoint_id = each.value.queue_id

  # Allows advanced filters to be evaluated against an array 
  # of values instead of expecting a singular value. This property 
  # exists for backwards compatibility purposes and it is recommended 
  # to keep it enabled for new event subscriptions.
  advanced_filtering_on_arrays_enabled = true
  included_event_types                 = each.value.event_types

  dynamic "advanced_filter" {
    for_each = each.value.begins_with_filters == null ? [] : each.value.begins_with_filters
    content {
      string_begins_with {
        key    = advanced_filter.value.key
        values = advanced_filter.value.values
      }
    }
  }
}

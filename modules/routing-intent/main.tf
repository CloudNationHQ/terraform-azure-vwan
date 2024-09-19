# routing intent
resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  for_each = var.configs

  name           = try(each.value.name, each.key)
  virtual_hub_id = each.value.virtual_hub_id

  dynamic "routing_policy" {
    for_each = each.value.routing_policies

    content {
      name         = routing_policy.key
      destinations = routing_policy.value.destinations
      next_hop     = routing_policy.value.next_hop
    }
  }
}

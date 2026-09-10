# virtual hub route tables
resource "azurerm_virtual_hub_route_table" "this" {
  for_each = var.route_tables

  name = coalesce(
    each.value.name, each.key
  )

  virtual_hub_id = each.value.virtual_hub_id
  labels         = each.value.labels

  dynamic "route" {
    for_each = each.value.routes

    content {
      name = coalesce(
        route.value.name, route.key
      )

      destinations_type = route.value.destinations_type
      destinations      = route.value.destinations
      next_hop_type     = route.value.next_hop_type
      next_hop          = route.value.next_hop
    }
  }
}

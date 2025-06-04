# virtual hub
data "azurerm_virtual_hub" "vhub" {
  name                = var.virtual_hub.name
  resource_group_name = var.virtual_hub.resource_group_name
}

# connections
resource "azurerm_virtual_hub_connection" "vcon" {
  for_each = var.virtual_hub.connections

  name = try(
    each.value.name, each.key
  )

  virtual_hub_id            = data.azurerm_virtual_hub.vhub.id
  remote_virtual_network_id = each.value.remote_virtual_network_id
  internet_security_enabled = each.value.internet_security_enabled

  dynamic "routing" {
    for_each = try(each.value.routing, null) != null ? [each.value.routing] : []

    content {
      outbound_route_map_id                       = routing.value.outbound_route_map_id
      inbound_route_map_id                        = routing.value.inbound_route_map_id
      associated_route_table_id                   = routing.value.associated_route_table_id
      static_vnet_local_route_override_criteria   = routing.value.static_vnet_local_route_override_criteria
      static_vnet_propagate_static_routes_enabled = routing.value.static_vnet_propagate_static_routes_enabled

      dynamic "propagated_route_table" {
        for_each = try(routing.value.propagated_route_table, null) != null ? [routing.value.propagated_route_table] : []

        content {
          labels          = propagated_route_table.value.labels
          route_table_ids = propagated_route_table.value.route_table_ids
        }
      }

      dynamic "static_vnet_route" {
        for_each = try(
          routing.value.static_vnet_route, {}
        )

        content {
          name                = static_vnet_route.value.name
          address_prefixes    = static_vnet_route.value.address_prefixes
          next_hop_ip_address = static_vnet_route.value.next_hop_ip_address
        }
      }
    }
  }
}

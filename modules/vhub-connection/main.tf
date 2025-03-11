# virtual hub
data "azurerm_virtual_hub" "vhub" {
  name                = var.virtual_hub.name
  resource_group_name = var.virtual_hub.resource_group
}

# connections
resource "azurerm_virtual_hub_connection" "vcon" {
  for_each = var.virtual_hub.connections

  name                      = try(each.value.name, each.key)
  virtual_hub_id            = data.azurerm_virtual_hub.vhub.id
  remote_virtual_network_id = each.value.remote_virtual_network_id
  internet_security_enabled = try(each.value.internet_security_enabled, true)

  dynamic "routing" {
    for_each = try(each.value.routing, null) != null ? [each.value.routing] : []

    content {
      outbound_route_map_id                     = try(routing.value.outbound_route_map_id, null)
      inbound_route_map_id                      = try(routing.value.inbound_route_map_id, null)
      associated_route_table_id                 = try(routing.value.associated_route_table_id, null)
      static_vnet_local_route_override_criteria = try(routing.value.static_vnet_local_route_override_criteria, null)

      dynamic "propagated_route_table" {
        for_each = try(routing.value.propagated_route_table, null) != null ? [routing.value.propagated_route_table] : []

        content {
          labels          = try(propagated_route_table.value.labels, null)
          route_table_ids = try(propagated_route_table.value.route_table_ids, [])
        }
      }

      dynamic "static_vnet_route" {
        for_each = try(
          routing.value.static_vnet_route, {}
        )

        content {
          name                = try(static_vnet_route.value.name, null)
          address_prefixes    = try(static_vnet_route.value.address_prefixes, null)
          next_hop_ip_address = try(static_vnet_route.value.next_hop_ip_address, null)
        }
      }
    }
  }
}

variable "virtual_hub" {
  description = "Contains all virtual hub connection configurations."
  type = object({
    name                = string
    resource_group_name = string
    connections = optional(map(object({
      name                      = optional(string)
      remote_virtual_network_id = string
      internet_security_enabled = optional(bool, true)
      routing = optional(object({
        outbound_route_map_id                       = optional(string)
        inbound_route_map_id                        = optional(string)
        associated_route_table_id                   = optional(string)
        static_vnet_local_route_override_criteria   = optional(string)
        static_vnet_propagate_static_routes_enabled = optional(bool, true)
        propagated_route_table = optional(object({
          labels          = optional(list(string))
          route_table_ids = optional(list(string), [])
        }))
        static_vnet_route = optional(map(object({
          name                = optional(string)
          address_prefixes    = optional(list(string))
          next_hop_ip_address = optional(string)
        })), {})
      }))
    })), {})
  })

  validation {
    condition = alltrue([
      for conn_key, conn in var.virtual_hub.connections : can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+$", conn.remote_virtual_network_id))
    ])
    error_message = "All remote_virtual_network_id values must be valid Azure Virtual Network resource IDs."
  }

  validation {
    condition = alltrue([
      for conn_key, conn in var.virtual_hub.connections : 
      try(conn.routing.associated_route_table_id, null) == null || can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualHubs/[^/]+/hubRouteTables/[^/]+$", conn.routing.associated_route_table_id))
    ])
    error_message = "All route table IDs must be valid Azure Virtual Hub Route Table resource IDs."
  }
}

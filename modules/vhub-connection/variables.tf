# variable "use_existing_hub" {
#   description = "Whether to use data source to reference existing hub (spoke) or direct resource reference (connectivity)"
#   type        = bool
#   default     = false # Default to connectivity scenario (direct reference)
# }

variable "virtual_hub" {
  description = "Contains all virtual hub connection configurations."
  type = object({
    # name                = optional(string, null) # For data source lookup
    # resource_group_name = optional(string, null) # For data source lookup
    connections = optional(map(object({
      name                      = optional(string, null)
      virtual_hub_id            = string
      remote_virtual_network_id = string
      internet_security_enabled = optional(bool, true)
      routing = optional(object({
        outbound_route_map_id                       = optional(string, null)
        inbound_route_map_id                        = optional(string, null)
        associated_route_table_id                   = optional(string, null)
        static_vnet_local_route_override_criteria   = optional(string, null)
        static_vnet_propagate_static_routes_enabled = optional(bool, true)
        propagated_route_table = optional(object({
          labels          = optional(list(string), null)
          route_table_ids = optional(list(string), [])
        }), null)
        static_vnet_route = optional(map(object({
          name                = optional(string, null)
          address_prefixes    = optional(list(string), null)
          next_hop_ip_address = optional(string, null)
        })), {})
      }), null)
    })), {})
  })
}

# variable "virtual_hub" {
#   description = "Contains all virtual hub connection configurations."
#   type = object({
#     name                = string
#     resource_group_name = string
#     connections = optional(map(object({
#       name                      = optional(string, null)
#       remote_virtual_network_id = string
#       internet_security_enabled = optional(bool, true)
#       routing = optional(object({
#         outbound_route_map_id                       = optional(string, null)
#         inbound_route_map_id                        = optional(string, null)
#         associated_route_table_id                   = optional(string, null)
#         static_vnet_local_route_override_criteria   = optional(string, null)
#         static_vnet_propagate_static_routes_enabled = optional(bool, true)
#         propagated_route_table = optional(object({
#           labels          = optional(list(string), null)
#           route_table_ids = optional(list(string), [])
#         }), null)
#         static_vnet_route = optional(map(object({
#           name                = optional(string, null)
#           address_prefixes    = optional(list(string), null)
#           next_hop_ip_address = optional(string, null)
#         })), {})
#       }), null)
#     })), {})
#   })
# }

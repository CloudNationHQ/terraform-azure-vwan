variable "route_tables" {
  description = "contains all virtual hub route tables configurations"
  type = map(object({
    virtual_hub_id = string
    name           = optional(string)
    labels         = list(string)
    routes = map(object({
      name              = optional(string)
      destinations_type = string
      destinations      = list(string)
      next_hop_type     = string
      next_hop          = string
    }))
  }))

  validation {
    condition = alltrue([
      for rt_key, rt in var.route_tables : can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualHubs/[^/]+$", rt.virtual_hub_id))
    ])
    error_message = "All virtual_hub_id values must be valid Azure Virtual Hub resource IDs."
  }

  validation {
    condition = alltrue([
      for rt_key, rt in var.route_tables : alltrue([
        for route_key, route in rt.routes : contains(["CIDR", "ResourceId", "Service"], route.destinations_type)
      ])
    ])
    error_message = "destinations_type must be one of: CIDR, ResourceId, Service."
  }

  validation {
    condition = alltrue([
      for rt_key, rt in var.route_tables : alltrue([
        for route_key, route in rt.routes : contains(["ResourceId"], route.next_hop_type)
      ])
    ])
    error_message = "next_hop_type must be: ResourceId."
  }

  validation {
    condition = alltrue([
      for rt_key, rt in var.route_tables : alltrue([
        for route_key, route in rt.routes : 
        route.destinations_type != "CIDR" || alltrue([
          for dest in route.destinations : can(cidrhost(dest, 0))
        ])
      ])
    ])
    error_message = "When destinations_type is 'CIDR', all destinations must be valid CIDR blocks."
  }
}

variable "naming" {
  description = "Used for naming purposes"
  type        = map(string)
  default     = {}
}

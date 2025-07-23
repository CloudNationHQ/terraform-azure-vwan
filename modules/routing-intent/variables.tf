variable "configs" {
  description = "Contains all routing intent configurations."
  type = map(object({
    name           = optional(string, null)
    virtual_hub_id = string
    routing_policies = map(object({
      name         = optional(string)
      destinations = list(string)
      next_hop     = string
    }))
  }))

  validation {
    condition = alltrue([
      for config_key, config in var.configs : can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualHubs/[^/]+$", config.virtual_hub_id))
    ])
    error_message = "All virtual_hub_id values must be valid Azure Virtual Hub resource IDs."
  }

  validation {
    condition = alltrue([
      for config_key, config in var.configs : length(config.routing_policies) > 0
    ])
    error_message = "Each routing intent configuration must have at least one routing policy."
  }

  validation {
    condition = alltrue([
      for config_key, config in var.configs : alltrue([
        for policy_key, policy in config.routing_policies : length(policy.destinations) > 0
      ])
    ])
    error_message = "Each routing policy must have at least one destination."
  }

  validation {
    condition = alltrue([
      for config_key, config in var.configs : alltrue([
        for policy_key, policy in config.routing_policies : can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/(Microsoft\\.Network/(azureFirewalls|networkVirtualAppliances)|Microsoft\\.Solutions/applications)/[^/]+$", policy.next_hop))
      ])
    ])
    error_message = "All next_hop values must be valid Azure Firewall or Network Virtual Appliance resource IDs."
  }
}

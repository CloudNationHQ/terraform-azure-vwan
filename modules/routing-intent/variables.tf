variable "configs" {
  description = "Contains all routing intent configurations."
  type = map(object({
    name           = optional(string)
    virtual_hub_id = string
    routing_policies = map(object({
      name         = optional(string)
      destinations = list(string)
      next_hop     = string
    }))
  }))
}

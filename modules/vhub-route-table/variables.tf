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
}

variable "naming" {
  description = "Used for naming purposes"
  type        = map(string)
  default     = null
}

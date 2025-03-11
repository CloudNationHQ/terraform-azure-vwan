This example showcases virtual wan integration by establishing a vhub connection (as a submodule).

## Types

```hcl
virtual_hub = object({
  resource_group = string
  name           = string
  connections    = map(object({
    name                      = optional(string)
    remote_virtual_network_id = string
    internet_security_enabled = optional(bool)
    routing                   = optional(object({
      associated_route_table_id = optional(string)
      propagated_route_table    = optional(object({
        labels          = optional(list(string))
        route_table_ids = optional(list(string))
      }))
    }))
  }))
})
```

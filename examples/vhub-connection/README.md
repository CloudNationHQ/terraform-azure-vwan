This example showcases virtual wan integration by establishing a vhub connection (as a submodule).

## Types

```hcl
peering = object({
  vnet_name                 = string
  resource_group            = string
  name                      = string
  vnet_id                   = string
  internet_security_enabled = optional(bool)
})

```

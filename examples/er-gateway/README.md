# ER Gateway

This enables a express route gateway on a virtual hub

## Types

```hcl
vwan = object({
  name                           = string
  allow_branch_to_branch_traffic = optional(bool, true)
  disable_vpn_encryption         = optional(bool, false)

  vhubs = optional(map(object({
    location       = string
    address_prefix = string

    express_route_gateway = optional(object({
      name        = optional(string)
      scale_units = number
    }))
  })))
})
```

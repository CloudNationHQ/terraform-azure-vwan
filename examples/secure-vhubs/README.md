# Secure Vhubs

This deploys secure vhubs within a virtual wan.

## Types

```hcl
vwan = object({
  name                           = string
  allow_branch_to_branch_traffic = optional(bool)
  disable_vpn_encryption         = optional(bool)
  vhubs = map(object({
    resource_group = string
    location       = string
    address_prefix = optional(string)
    sku            = optional(string)
  }))
})
```

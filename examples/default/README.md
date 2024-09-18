# Default

This example illustrates the default setup, in its simplest form.

## Types

```hcl
vwan = object({
  name             = string
  resource_group   = string
  location         = string
  allow_branch_to_branch_traffic = optional(bool)
  disable_vpn_encryption         = optional(bool)
})
```

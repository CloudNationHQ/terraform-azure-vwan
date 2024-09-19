# Vpn Site to Site

This deploys a vpn site to site configuration

## Types

```hcl
vwan = object({
  name                           = string
  allow_branch_to_branch_traffic = optional(bool)
  disable_vpn_encryption         = optional(bool)
  vhubs = optional(map(object({
    location       = string
    address_prefix = optional(string)
    vpn_gateway = optional(object({
      name = string
      vpn_sites = map(object({
        address_prefix = string
        gateway_ip     = string
        vpn_links = map(object({
          ip_address    = string
          provider_name = string
          speed_in_mbps = number
        }))
        connections = optional(map(object({
          shared_key            = string
          connection_type       = string
          routing_weight        = number
          local_address_ranges  = list(string)
          remote_address_ranges = list(string)
          vpn_links = map(object({
            shared_key  = string
            bgp_enabled = bool
            protocol    = string
          }))
        })))
      }))
    }))
  })))
})
```

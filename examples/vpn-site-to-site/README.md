# Vpn Site to Site

This deploys a vpn site to site configuration

## Types

```hcl
vwan = object({
  name                           = string
  allow_branch_to_branch_traffic = optional(bool, true)
  disable_vpn_encryption         = optional(bool, false)

  vhubs = map(object({
    location       = string
    address_prefix = string

    site_to_site_vpn = optional(object({
      name = string

      nat_rules = optional(map(object({
        external_mappings = map(object({
          address_space = string
          port_range    = optional(string)
        }))
        internal_mappings = map(object({
          address_space = string
          port_range    = optional(string)
        }))
      })))

      vpn_sites = map(object({
        address_prefix = string
        gateway_ip     = string

        vpn_links = map(object({
          ip_address    = string
          provider_name = optional(string)
          speed_in_mbps = optional(number)
        }))

        connections = map(object({
          shared_key            = string
          connection_type       = string
          routing_weight        = optional(number)
          local_address_ranges  = list(string)
          remote_address_ranges = list(string)

          vpn_links = map(object({
            shared_key  = string
            bgp_enabled = optional(bool, false)
            protocol    = optional(string, "IKEv2")
          }))
        }))
      }))
    }))
  }))
})
```

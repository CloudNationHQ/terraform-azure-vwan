# Vpn Point to Site

This deploys a vpn point to site configuration

## Types

```hcl
vwan = object({
  name                           = string
  allow_branch_to_branch_traffic = optional(bool)
  disable_vpn_encryption         = optional(bool)
  vhubs = optional(map(object({
    location       = string
    address_prefix = optional(string)
    point_to_site_vpn = optional(object({
      vpn_server_configuration_name = string
      gateway_name                  = string
      scale_unit                    = number
      authentication_types          = list(string)

      client_root_certificates = optional(map(object({
        name             = string
        public_cert_data = string
      })))

      client_revoked_certificates = optional(map(object({
        name       = string
        thumbprint = string
      })))

      vpn_client_configuration = object({
        address_pool     = list(string)
        dns_servers      = optional(list(string))
        included_routes  = optional(list(string))
      })

      ipsec_policy = optional(object({
        sa_lifetime_seconds     = number
        sa_data_size_kilobytes = number
        ipsec_encryption       = string
        ipsec_integrity        = string
        ike_encryption         = string
        ike_integrity          = string
        dh_group              = string
        pfs_group             = string
      }))
    }))
  })))
})
```

# Virtual Wan

This terraform module streamlines the setup and management of virtual wan components on azure, offering customizable choices for wan topology, connectivity and security policies.

## Features

Simplified virtual wan deployment

Multiple secure virtual hub support

Utilization of terratest for robust validation

Ability to define and manage routing intents on virtual hubs

Vpn gateway support on virtual hubs with multi-site and link connectivity

Ability to configure multiple vpn gateway connections on sites

Site to site vpn capabilities for secure connectivity between networks

Point to site vpn support for secure client access to virtual hub

Nat rules support for address translation on vpn gateways

Expressroute gateway enablement on virtual hubs for hybrid connectivity

Custom virtual hub route tables with flexible routing configurations

Offers three-tier naming hierarchy (explicit, convention-based, or key-based) for flexible resource management.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_express_route_gateway.er_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) (resource)
- [azurerm_point_to_site_vpn_gateway.p2s_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/point_to_site_vpn_gateway) (resource)
- [azurerm_virtual_hub.vhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub) (resource)
- [azurerm_virtual_hub_security_partner_provider.spp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_security_partner_provider) (resource)
- [azurerm_virtual_wan.vwan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan) (resource)
- [azurerm_vpn_gateway.vpn_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway) (resource)
- [azurerm_vpn_gateway_connection.vpn_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway_connection) (resource)
- [azurerm_vpn_gateway_nat_rule.nat_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway_nat_rule) (resource)
- [azurerm_vpn_server_configuration.p2s_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_server_configuration) (resource)
- [azurerm_vpn_site.vpn_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_site) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_vwan"></a> [vwan](#input\_vwan)

Description: Contains all virtual wan configuration

Type:

```hcl
object({
    name                              = string
    resource_group_name               = optional(string, null)
    location                          = optional(string, null)
    allow_branch_to_branch_traffic    = optional(bool, true)
    disable_vpn_encryption            = optional(bool, false)
    type                              = optional(string, "Standard")
    office365_local_breakout_category = optional(string, "None")
    tags                              = optional(map(string))
    vhubs = optional(map(object({
      name                                   = optional(string)
      resource_group_name                    = optional(string, null)
      location                               = optional(string, null)
      address_prefix                         = string
      sku                                    = optional(string, "Standard")
      hub_routing_preference                 = optional(string, "ExpressRoute")
      virtual_router_auto_scale_min_capacity = optional(number, 2)
      tags                                   = optional(map(string))
      routes = optional(map(object({
        address_prefixes    = list(string)
        next_hop_ip_address = string
      })), {})
      point_to_site_vpn = optional(object({
        vpn_server_configuration_name       = optional(string)
        authentication_types                = optional(list(string), ["Certificate"])
        protocols                           = optional(list(string), ["IkeV2"])
        scale_unit                          = optional(number, 1)
        routing_preference_internet_enabled = optional(bool, false)
        internet_security_enabled           = optional(bool, false)
        dns_servers                         = optional(list(string), [])
        connection_configuration_name       = optional(string)
        ipsec_policy = optional(object({
          dh_group               = string
          pfs_group              = string
          ike_integrity          = string
          ike_encryption         = string
          ipsec_integrity        = string
          ipsec_encryption       = string
          sa_lifetime_seconds    = number
          sa_data_size_kilobytes = number
        }))
        radius = optional(object({
          server = list(object({
            address = string
            secret  = string
            score   = number
          }))
          client_root_certificate = optional(object({
            name       = string
            thumbprint = string
          }))
          server_root_certificate = optional(object({
            name             = string
            public_cert_data = string
          }))
        }))
        client_root_certificates = optional(map(object({
          name             = optional(string)
          public_cert_data = string
        })), {})
        client_revoked_certificates = optional(map(object({
          name       = optional(string)
          thumbprint = string
        })), {})
        azure_active_directory = optional(object({
          audience = string
          issuer   = string
          tenant   = string
        }))
        vpn_client_configuration = object({
          address_pool = list(string)
        })
        route = optional(object({
          associated_route_table_id = string
          inbound_route_map_id      = optional(string)
          outbound_route_map_id     = optional(string)
          propagated_route_table = optional(object({
            ids    = list(string)
            labels = optional(list(string), [])
          }))
        }))
      }))
      site_to_site_vpn = optional(object({
        name                                  = string
        resource_group_name                   = optional(string, null)
        routing_preference                    = optional(string, null)
        bgp_route_translation_for_nat_enabled = optional(bool, false)
        scale_unit                            = optional(number, 1)
        tags                                  = optional(map(string))
        bgp_settings = optional(object({
          asn         = number
          peer_weight = number
          instance_0_bgp_peering_address = optional(object({
            custom_ips = list(string)
          }))
          instance_1_bgp_peering_address = optional(object({
            custom_ips = list(string)
          }))
        }))
        vpn_sites = optional(map(object({
          name                = optional(string)
          resource_group_name = optional(string, null)
          address_cidrs       = optional(list(string), [])
          device_vendor       = optional(string, "Microsoft")
          device_model        = optional(string)
          o365_policy = optional(object({
            traffic_category = optional(object({
              allow_endpoint_enabled    = optional(bool, false)
              default_endpoint_enabled  = optional(bool, false)
              optimize_endpoint_enabled = optional(bool, false)
            }))
          }))
          vpn_links = optional(map(object({
            name          = optional(string)
            ip_address    = optional(string, null)
            provider_name = optional(string, null)
            speed_in_mbps = optional(number, null)
            fqdn          = optional(string, null)
            bgp = optional(object({
              peering_address = string
              asn             = number
            }))
          })), { "link1" = {} })
          connections = optional(map(object({
            name                      = optional(string)
            internet_security_enabled = optional(bool, false)
            routing = optional(object({
              associated_route_table = optional(string)
              inbound_route_map_id   = optional(string)
              outbound_route_map_id  = optional(string)
              propagated_route_table = optional(object({
                route_table_ids = optional(list(string))
                labels          = optional(list(string), [])
              }))
            }))
            traffic_selector_policy = optional(map(object({
              local_address_ranges  = list(string)
              remote_address_ranges = list(string)
            })), {})
            vpn_links = map(object({
              name                                  = optional(string)
              shared_key                            = optional(string, null)
              bgp_enabled                           = optional(bool, false)
              protocol                              = optional(string, "IKEv2")
              ingress_nat_rule_ids                  = optional(list(string), [])
              egress_nat_rule_ids                   = optional(list(string), [])
              bandwidth_mbps                        = optional(number, 10)
              connection_mode                       = optional(string, "Default")
              local_azure_ip_address_enabled        = optional(bool, false)
              policy_based_traffic_selector_enabled = optional(bool, false)
              ratelimit_enabled                     = optional(bool, false)
              route_weight                          = optional(number, 0)
              vpn_site_link_id                      = optional(string)
              custom_bgp_address = optional(map(object({
                ip_address          = string
                ip_configuration_id = string
              })), {})
              ipsec_policy = optional(map(object({
                pfs_group                = string
                dh_group                 = string
                sa_data_size_kb          = number
                sa_lifetime_sec          = number
                integrity_algorithm      = string
                encryption_algorithm     = string
                ike_integrity_algorithm  = string
                ike_encryption_algorithm = string
              })), {})
            }))
          })), {})
        })), {})
        nat_rules = optional(map(object({
          name                = optional(string)
          ip_configuration_id = optional(string, null)
          mode                = optional(string, "EgressSnat")
          type                = optional(string, "Static")
          external_mappings = map(object({
            address_space = string
            port_range    = optional(string, null)
          }))
          internal_mappings = map(object({
            address_space = string
            port_range    = optional(string, null)
          }))
        })), {})
      }), null)
      express_route_gateway = optional(object({
        name                          = optional(string)
        resource_group_name           = optional(string, null)
        scale_units                   = number
        allow_non_virtual_wan_traffic = optional(bool, false)
        tags                          = optional(map(string))
      }))
      security_partner_provider = optional(object({
        name                   = string
        security_provider_name = string
      }))
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region and can be used if location is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: contains naming convention

Type: `map(string)`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group and can be used if resourcegroup is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: default tags to be used.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_vhubs"></a> [vhubs](#output\_vhubs)

Description: contains virtual hub configuration

### <a name="output_vwan"></a> [vwan](#output\_vwan)

Description: contains virtual wan configuration
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-vwan/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-vwan" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/virtual-wan/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/virtualwan/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/network/resource-manager/Microsoft.Network/stable/2023-09-01/virtualWan.json)

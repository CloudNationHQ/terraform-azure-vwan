variable "vwan" {
  description = "Contains all virtual wan configuration"
  type = object({
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
          name          = optional(string)
          address_cidrs = optional(list(string), [])
          device_vendor = optional(string, "Microsoft")
          device_model  = optional(string)
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
      }))
      security_partner_provider = optional(object({
        name                   = string
        security_provider_name = string
      }))
    })), {})
  })

  validation {
    condition     = var.vwan.location != null || var.location != null
    error_message = "location must be provided either in the object or as a separate variable."
  }

  validation {
    condition     = var.vwan.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the object or as a separate variable."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = null
}

variable "location" {
  description = "default azure region and can be used if location is not specified inside the object."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}

variable "tags" {
  description = "default tags to be used."
  type        = map(string)
  default     = {}
}

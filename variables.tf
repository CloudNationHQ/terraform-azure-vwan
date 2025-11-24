variable "vwan" {
  description = "Contains all virtual wan configuration"
  type = object({
    name                              = string
    resource_group_name               = optional(string)
    location                          = optional(string)
    use_existing_vwan                 = optional(bool, false)
    allow_branch_to_branch_traffic    = optional(bool, true)
    disable_vpn_encryption            = optional(bool, false)
    type                              = optional(string, "Standard")
    office365_local_breakout_category = optional(string, "None")
    tags                              = optional(map(string))
    vhubs = optional(map(object({
      name                                   = optional(string)
      resource_group_name                    = optional(string)
      location                               = optional(string)
      address_prefix                         = string
      sku                                    = optional(string, "Standard")
      hub_routing_preference                 = optional(string, "ExpressRoute")
      branch_to_branch_traffic_enabled       = optional(bool, false)
      virtual_router_auto_scale_min_capacity = optional(number, 2)
      tags                                   = optional(map(string))
      routes = optional(map(object({
        address_prefixes    = list(string)
        next_hop_ip_address = string
      })), {})
      point_to_site_vpn = optional(object({
        name                                = optional(string)
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
        resource_group_name                   = optional(string)
        routing_preference                    = optional(string)
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
          resource_group_name = optional(string)
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
            ip_address    = optional(string)
            provider_name = optional(string)
            speed_in_mbps = optional(number)
            fqdn          = optional(string)
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
              shared_key                            = optional(string)
              bgp_enabled                           = optional(bool, false)
              dpd_timeout_seconds                   = optional(number)
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
          ip_configuration_id = optional(string)
          mode                = optional(string, "EgressSnat")
          type                = optional(string, "Static")
          external_mappings = map(object({
            address_space = string
            port_range    = optional(string)
          }))
          internal_mappings = map(object({
            address_space = string
            port_range    = optional(string)
          }))
        })), {})
      }))
      express_route_gateway = optional(object({
        name                          = optional(string)
        resource_group_name           = optional(string)
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

  validation {
    condition     = var.vwan.location != null || var.location != null
    error_message = "location must be provided either in the object or as a separate variable."
  }

  validation {
    condition     = var.vwan.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the object or as a separate variable."
  }

  validation {
    condition     = var.vwan.type == null || contains(["Standard", "Basic"], var.vwan.type)
    error_message = "Virtual WAN type must be either 'Standard' or 'Basic'."
  }

  validation {
    condition     = var.vwan.office365_local_breakout_category == null || contains(["None", "Optimize", "OptimizeAndAllow", "All"], var.vwan.office365_local_breakout_category)
    error_message = "Office365 local breakout category must be one of: 'None', 'Optimize', 'OptimizeAndAllow', 'All'."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs : hub.sku == null || contains(["Basic", "Standard"], hub.sku)
    ])
    error_message = "Virtual Hub SKU must be either 'Basic' or 'Standard'."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs : hub.hub_routing_preference == null || contains(["ExpressRoute", "VpnGateway", "ASPath"], hub.hub_routing_preference)
    ])
    error_message = "Virtual Hub routing preference must be one of: 'ExpressRoute', 'VpnGateway', 'ASPath'."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs : hub.virtual_router_auto_scale_min_capacity == null || (hub.virtual_router_auto_scale_min_capacity >= 2 && hub.virtual_router_auto_scale_min_capacity <= 50)
    ])
    error_message = "Virtual Hub auto scale minimum capacity must be between 2 and 50."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs : can(cidrhost(hub.address_prefix, 0))
    ])
    error_message = "Virtual Hub address prefix must be a valid CIDR notation (e.g., '10.0.0.0/24')."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs :
      hub.point_to_site_vpn == null || alltrue([
        for auth_type in hub.point_to_site_vpn.authentication_types : contains(["Certificate", "Radius", "AAD"], auth_type)
      ])
    ])
    error_message = "Point-to-Site VPN authentication types must be from: 'Certificate', 'Radius', 'AAD'."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs :
      hub.point_to_site_vpn == null || alltrue([
        for protocol in hub.point_to_site_vpn.protocols : contains(["IkeV2", "OpenVPN"], protocol)
      ])
    ])
    error_message = "Point-to-Site VPN protocols must be from: 'IkeV2', 'OpenVPN'."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs :
      hub.point_to_site_vpn == null || (hub.point_to_site_vpn.scale_unit >= 1 && hub.point_to_site_vpn.scale_unit <= 20)
    ])
    error_message = "Point-to-Site VPN scale unit must be between 1 and 20."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs :
      hub.site_to_site_vpn == null || hub.site_to_site_vpn.routing_preference == null || contains(["Microsoft Network", "Internet"], hub.site_to_site_vpn.routing_preference)
    ])
    error_message = "Site-to-Site VPN routing preference must be either 'Microsoft Network' or 'Internet'."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs :
      hub.site_to_site_vpn == null || (hub.site_to_site_vpn.scale_unit >= 1 && hub.site_to_site_vpn.scale_unit <= 20)
    ])
    error_message = "Site-to-Site VPN scale unit must be between 1 and 20."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs :
      hub.site_to_site_vpn == null || hub.site_to_site_vpn.bgp_settings == null ||
      (hub.site_to_site_vpn.bgp_settings.asn >= 1 && hub.site_to_site_vpn.bgp_settings.asn <= 4294967295 && hub.site_to_site_vpn.bgp_settings.asn != 65515)
    ])
    error_message = "BGP ASN must be between 1 and 4294967295, and cannot be 65515 (reserved by Azure)."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs :
      hub.site_to_site_vpn == null || hub.site_to_site_vpn.bgp_settings == null ||
      (hub.site_to_site_vpn.bgp_settings.peer_weight >= 0 && hub.site_to_site_vpn.bgp_settings.peer_weight <= 100)
    ])
    error_message = "BGP peer weight must be between 0 and 100."
  }

  validation {
    condition = alltrue(flatten([
      for hub_key, hub in var.vwan.vhubs : [
        for site_key, site in(hub.site_to_site_vpn != null ? hub.site_to_site_vpn.vpn_sites : {}) : [
          for conn_key, conn in site.connections : [
            for link_key, link in conn.vpn_links :
            link.connection_mode == null || contains(["Default", "InitiatorOnly", "ResponderOnly"], link.connection_mode)
          ]
        ]
      ]
    ]))
    error_message = "VPN connection mode must be one of: 'Default', 'InitiatorOnly', 'ResponderOnly'."
  }

  validation {
    condition = alltrue(flatten([
      for hub_key, hub in var.vwan.vhubs : [
        for site_key, site in(hub.site_to_site_vpn != null ? hub.site_to_site_vpn.vpn_sites : {}) : [
          for conn_key, conn in site.connections : [
            for link_key, link in conn.vpn_links :
            link.bandwidth_mbps == null || (link.bandwidth_mbps >= 10 && link.bandwidth_mbps <= 10000)
          ]
        ]
      ]
    ]))
    error_message = "VPN connection bandwidth must be between 10 and 10000 Mbps."
  }

  validation {
    condition = alltrue(flatten([
      for hub_key, hub in var.vwan.vhubs : [
        for site_key, site in(hub.site_to_site_vpn != null ? hub.site_to_site_vpn.vpn_sites : {}) : [
          for conn_key, conn in site.connections : [
            for link_key, link in conn.vpn_links :
            link.route_weight == null || (link.route_weight >= 0 && link.route_weight <= 32000)
          ]
        ]
      ]
    ]))
    error_message = "VPN connection route weight must be between 0 and 32000."
  }

  validation {
    condition = alltrue([
      for hub_key, hub in var.vwan.vhubs :
      hub.express_route_gateway == null || (hub.express_route_gateway.scale_units >= 1 && hub.express_route_gateway.scale_units <= 20)
    ])
    error_message = "ExpressRoute Gateway scale units must be between 1 and 20."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
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

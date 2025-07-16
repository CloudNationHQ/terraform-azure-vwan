# virtual wan
resource "azurerm_virtual_wan" "vwan" {

  resource_group_name = coalesce(
    lookup(
      var.vwan, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.vwan, "location", null
    ), var.location
  )

  name                              = var.vwan.name
  allow_branch_to_branch_traffic    = var.vwan.allow_branch_to_branch_traffic
  disable_vpn_encryption            = var.vwan.disable_vpn_encryption
  type                              = var.vwan.type
  office365_local_breakout_category = var.vwan.office365_local_breakout_category

  tags = coalesce(
    var.vwan.tags, var.tags
  )
}

# vhubs
resource "azurerm_virtual_hub" "vhub" {
  for_each = lookup(
    var.vwan, "vhubs", {}
  )

  resource_group_name = coalesce(
    lookup(
      each.value, "resource_group_name", null
    ),
    lookup(
      var.vwan, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(each.value, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, try(
      join("-", [var.naming.virtual_hub, each.key]), null
    ), each.key
  )

  address_prefix                         = each.value.address_prefix
  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  sku                                    = each.value.sku
  hub_routing_preference                 = each.value.hub_routing_preference
  virtual_router_auto_scale_min_capacity = each.value.virtual_router_auto_scale_min_capacity

  tags = coalesce(
    each.value.tags, var.tags
  )

  dynamic "route" {
    for_each = try(
      each.value.routes, {}
    )

    content {
      address_prefixes    = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }
}

resource "azurerm_vpn_server_configuration" "p2s_config" {
  for_each = nonsensitive({
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "point_to_site_vpn", null
    ) != null
  })

  resource_group_name = coalesce(
    lookup(
      var.vwan, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(
      each.value, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.point_to_site_vpn.vpn_server_configuration_name, "p2s-vpn-config-${each.key}"
  )

  vpn_authentication_types = each.value.point_to_site_vpn.authentication_types
  vpn_protocols            = each.value.point_to_site_vpn.protocols

  tags = try(
    var.vwan.tags, var.tags
  )

  dynamic "ipsec_policy" {
    for_each = try(each.value.point_to_site_vpn.ipsec_policy, null) != null ? [each.value.point_to_site_vpn.ipsec_policy] : []

    content {
      dh_group               = ipsec_policy.value.dh_group
      pfs_group              = ipsec_policy.value.pfs_group
      ike_integrity          = ipsec_policy.value.ike_integrity
      ike_encryption         = ipsec_policy.value.ike_encryption
      ipsec_integrity        = ipsec_policy.value.ipsec_integrity
      ipsec_encryption       = ipsec_policy.value.ipsec_encryption
      sa_lifetime_seconds    = ipsec_policy.value.sa_lifetime_seconds
      sa_data_size_kilobytes = ipsec_policy.value.sa_data_size_kilobytes
    }
  }

  dynamic "radius" {
    for_each = try(each.value.point_to_site_vpn.radius, null) != null ? [each.value.point_to_site_vpn.radius] : []

    content {
      dynamic "server" {
        for_each = radius.value.server

        content {
          address = server.value.address
          secret  = server.value.secret
          score   = server.value.score
        }
      }

      dynamic "client_root_certificate" {
        for_each = try(radius.value.client_root_certificate, null) != null ? [1] : []

        content {
          name       = radius.value.client_root_certificate.name
          thumbprint = radius.value.client_root_certificate.thumbprint
        }
      }

      dynamic "server_root_certificate" {
        for_each = try(radius.value.server_root_certificate, null) != null ? [1] : []

        content {
          name             = radius.value.server_root_certificate.name
          public_cert_data = radius.value.server_root_certificate.public_cert_data
        }
      }
    }
  }

  dynamic "client_root_certificate" {
    for_each = try(
      each.value.point_to_site_vpn.client_root_certificates, {}
    )

    content {
      name             = try(client_root_certificate.value.name, client_root_certificate.key)
      public_cert_data = client_root_certificate.value.public_cert_data
    }
  }

  dynamic "client_revoked_certificate" {
    for_each = try(
      each.value.point_to_site_vpn.client_revoked_certificates, {}
    )

    content {
      name       = try(client_revoked_certificate.value.name, client_revoked_certificate.key)
      thumbprint = client_revoked_certificate.value.thumbprint
    }
  }

  dynamic "azure_active_directory_authentication" {
    for_each = try(each.value.point_to_site_vpn.azure_active_directory, null) != null ? ["enabled"] : []

    content {
      audience = each.value.point_to_site_vpn.azure_active_directory.audience
      issuer   = each.value.point_to_site_vpn.azure_active_directory.issuer
      tenant   = each.value.point_to_site_vpn.azure_active_directory.tenant
    }
  }
}

# point to site vpn gateway
resource "azurerm_point_to_site_vpn_gateway" "p2s_gateway" {
  for_each = nonsensitive({
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "point_to_site_vpn", null
    ) != null
  })

  resource_group_name = coalesce(
    lookup(var.vwan, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(each.value, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, try(
      join("-", [var.naming.point_to_site_vpn_gateway, each.key]), null
    ), each.key
  )

  virtual_hub_id                      = azurerm_virtual_hub.vhub[each.key].id
  vpn_server_configuration_id         = azurerm_vpn_server_configuration.p2s_config[each.key].id
  scale_unit                          = each.value.point_to_site_vpn.scale_unit
  routing_preference_internet_enabled = each.value.point_to_site_vpn.routing_preference_internet_enabled
  dns_servers                         = each.value.point_to_site_vpn.dns_servers

  tags = try(
    each.value.tags, var.tags
  )

  connection_configuration {
    name = coalesce(
      each.value.point_to_site_vpn.connection_configuration_name, "p2s-connection-${each.key}"
    )

    internet_security_enabled = each.value.point_to_site_vpn.internet_security_enabled

    vpn_client_address_pool {
      address_prefixes = each.value.point_to_site_vpn.vpn_client_configuration.address_pool
    }

    dynamic "route" {
      for_each = try(each.value.point_to_site_vpn.route, null) != null ? [each.value.point_to_site_vpn.route] : []

      content {
        associated_route_table_id = route.value.associated_route_table_id
        inbound_route_map_id      = route.value.inbound_route_map_id
        outbound_route_map_id     = route.value.outbound_route_map_id

        dynamic "propagated_route_table" {
          for_each = try(route.value.propagated_route_table, null) != null ? [route.value.propagated_route_table] : []

          content {
            ids    = propagated_route_table.value.ids
            labels = propagated_route_table.value.labels
          }
        }
      }
    }
  }
}

resource "azurerm_vpn_gateway" "vpn_gateway" {
  for_each = nonsensitive({
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "site_to_site_vpn", null
    ) != null
  })

  resource_group_name = coalesce(
    lookup(
      lookup(each.value, "site_to_site_vpn", {}), "resource_group_name", null
    ),
    lookup(
      var.vwan, "resource_group_name", null
    ),
    var.resource_group_name
  )

  location = coalesce(
    lookup(each.value, "location", null
    ), var.location
  )

  name = lookup(
    each.value.site_to_site_vpn, "name", null
  )

  virtual_hub_id                        = azurerm_virtual_hub.vhub[each.key].id
  routing_preference                    = each.value.site_to_site_vpn.routing_preference
  bgp_route_translation_for_nat_enabled = each.value.site_to_site_vpn.bgp_route_translation_for_nat_enabled
  scale_unit                            = each.value.site_to_site_vpn.scale_unit

  tags = coalesce(
    each.value.tags, var.tags
  )

  dynamic "bgp_settings" {
    for_each = try(each.value.site_to_site_vpn.bgp_settings, null) != null ? [each.value.site_to_site_vpn.bgp_settings] : []

    content {
      asn         = bgp_settings.value.asn
      peer_weight = bgp_settings.value.peer_weight

      dynamic "instance_0_bgp_peering_address" {
        for_each = try(bgp_settings.value.instance_0_bgp_peering_address, null) != null ? [bgp_settings.value.instance_0_bgp_peering_address] : []

        content {
          custom_ips = instance_0_bgp_peering_address.value.custom_ips
        }
      }

      dynamic "instance_1_bgp_peering_address" {
        for_each = try(bgp_settings.value.instance_1_bgp_peering_address, null) != null ? [bgp_settings.value.instance_1_bgp_peering_address] : []

        content {
          custom_ips = instance_1_bgp_peering_address.value.custom_ips
        }
      }
    }
  }
}

# vpn sites
resource "azurerm_vpn_site" "vpn_site" {
  for_each = nonsensitive(merge(flatten([
    for vhub_key, vhub in lookup(var.vwan, "vhubs", {}) :
    vhub.site_to_site_vpn != null ? [
      for site_key, site in lookup(vhub.site_to_site_vpn, "vpn_sites", {}) : {
        "${vhub_key}-${site_key}" = merge(site, {
          vhub_key      = vhub_key
          site_key      = site_key
          vhub_location = lookup(vhub, "location", null)
        })
      }
    ] : []
  ])...))


  resource_group_name = coalesce(
    lookup(each.value, "resource_group_name", null),
    lookup(var.vwan, "resource_group_name", null),
    var.resource_group_name
  )

  location = coalesce(
    each.value.vhub_location, lookup(
      var.vwan, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.name, try(
      join("-", [var.naming.vpn_site, "${each.value.vhub_key}-${each.value.site_key}"]), null
    ), each.key
  )

  virtual_wan_id = azurerm_virtual_wan.vwan.id
  address_cidrs  = each.value.address_cidrs
  device_vendor  = each.value.device_vendor
  device_model   = each.value.device_model

  tags = try(
    var.vwan.tags, var.tags
  )

  dynamic "o365_policy" {
    for_each = try(each.value.o365_policy, null) != null ? [each.value.o365_policy] : []

    content {
      dynamic "traffic_category" {
        for_each = try(each.value.o365_policy.traffic_category, null) != null ? [each.value.o365_policy.traffic_category] : []

        content {
          allow_endpoint_enabled    = traffic_category.value.allow_endpoint_enabled
          default_endpoint_enabled  = traffic_category.value.default_endpoint_enabled
          optimize_endpoint_enabled = traffic_category.value.optimize_endpoint_enabled
        }
      }
    }
  }

  dynamic "link" {
    for_each = lookup(each.value, "vpn_links", { "link1" = {} })

    content {
      name = coalesce(
        link.value.name, link.key
      )

      ip_address    = link.value.ip_address
      provider_name = link.value.provider_name
      speed_in_mbps = link.value.speed_in_mbps
      fqdn          = link.value.fqdn

      dynamic "bgp" {
        for_each = try(link.value.bgp, null) != null ? [link.value.bgp] : []

        content {
          peering_address = bgp.value.peering_address
          asn             = bgp.value.asn
        }
      }
    }
  }
}

# vpn gateway connections
resource "azurerm_vpn_gateway_connection" "vpn_connection" {
  for_each = nonsensitive(merge(flatten([
    for vhub_key, vhub in lookup(var.vwan, "vhubs", {}) :
    vhub.site_to_site_vpn != null ? [
      for site_key, site in lookup(vhub.site_to_site_vpn, "vpn_sites", {}) : [
        for conn_key, conn in lookup(site, "connections", {}) : {
          "${vhub_key}-${site_key}-${conn_key}" = merge(conn, {
            vhub_key = vhub_key
            site_key = site_key
            conn_key = conn_key
          })
        }
      ]
    ] : []
  ])...))

  name = coalesce(
    each.value.name,
    join("-", [var.naming.vpn_gateway_connection, "${each.value.vhub_key}-${each.value.site_key}-${each.value.conn_key}"])
  )

  vpn_gateway_id            = azurerm_vpn_gateway.vpn_gateway[each.value.vhub_key].id
  remote_vpn_site_id        = azurerm_vpn_site.vpn_site["${each.value.vhub_key}-${each.value.site_key}"].id
  internet_security_enabled = each.value.internet_security_enabled

  dynamic "vpn_link" {
    for_each = lookup(
      each.value, "vpn_links", {}
    )

    content {
      name = coalesce(
        vpn_link.value.name, vpn_link.key
      )

      vpn_site_link_id = one([
        for link in azurerm_vpn_site.vpn_site["${each.value.vhub_key}-${each.value.site_key}"].link :
        link.id if link.name == coalesce(vpn_link.value.name, vpn_link.key)
      ])

      bgp_enabled                           = vpn_link.value.bgp_enabled
      protocol                              = vpn_link.value.protocol
      shared_key                            = vpn_link.value.shared_key
      ingress_nat_rule_ids                  = vpn_link.value.ingress_nat_rule_ids
      egress_nat_rule_ids                   = vpn_link.value.egress_nat_rule_ids
      bandwidth_mbps                        = vpn_link.value.bandwidth_mbps
      connection_mode                       = vpn_link.value.connection_mode
      local_azure_ip_address_enabled        = vpn_link.value.local_azure_ip_address_enabled
      policy_based_traffic_selector_enabled = vpn_link.value.policy_based_traffic_selector_enabled
      ratelimit_enabled                     = vpn_link.value.ratelimit_enabled
      route_weight                          = vpn_link.value.route_weight

      dynamic "custom_bgp_address" {
        for_each = try(
          vpn_link.value.custom_bgp_address, {}
        )

        content {
          ip_address          = custom_bgp_address.value.ip_address
          ip_configuration_id = custom_bgp_address.value.ip_configuration_id
        }
      }

      dynamic "ipsec_policy" {
        for_each = try(
          vpn_link.value.ipsec_policy, {}
        )

        content {
          pfs_group                = ipsec_policy.value.pfs_group
          dh_group                 = ipsec_policy.value.dh_group
          sa_data_size_kb          = ipsec_policy.value.sa_data_size_kb
          sa_lifetime_sec          = ipsec_policy.value.sa_lifetime_sec
          integrity_algorithm      = ipsec_policy.value.integrity_algorithm
          encryption_algorithm     = ipsec_policy.value.encryption_algorithm
          ike_integrity_algorithm  = ipsec_policy.value.ike_integrity_algorithm
          ike_encryption_algorithm = ipsec_policy.value.ike_encryption_algorithm
        }
      }
    }
  }

  dynamic "routing" {
    for_each = try(each.value.routing, null) != null ? [each.value.routing] : []

    content {
      associated_route_table = try(
        each.value.routing.associated_route_table, azurerm_virtual_hub.vhub[each.value.vhub_key].default_route_table_id
      )

      inbound_route_map_id  = routing.value.inbound_route_map_id
      outbound_route_map_id = routing.value.outbound_route_map_id

      dynamic "propagated_route_table" {
        for_each = try(routing.value.propagated_route_table, null) != null ? [routing.value.propagated_route_table] : []

        content {
          route_table_ids = try(
            propagated_route_table.value.route_table_ids,
            [azurerm_virtual_hub.vhub[each.value.vhub_key].default_route_table_id]
          )
          labels = propagated_route_table.value.labels
        }
      }
    }
  }

  dynamic "traffic_selector_policy" {
    for_each = lookup(each.value, "traffic_selector_policy", {})

    content {
      local_address_ranges  = traffic_selector_policy.value.local_address_ranges
      remote_address_ranges = traffic_selector_policy.value.remote_address_ranges
    }
  }
}

# vpn gateway nat rules
resource "azurerm_vpn_gateway_nat_rule" "nat_rule" {
  for_each = merge(flatten([
    for vhub_key, vhub in lookup(var.vwan, "vhubs", {}) : [
      for rule_key, rule in try(vhub.site_to_site_vpn.nat_rules, {}) : {
        "${vhub_key}-${rule_key}" = merge(rule, {
          vhub_key = vhub_key
          rule_key = rule_key
        })
      }
    ]
  ])...)

  name = coalesce(
    lookup(
      each.value, "name", null
    ), each.value.rule_key
  )

  vpn_gateway_id      = azurerm_vpn_gateway.vpn_gateway[each.value.vhub_key].id
  ip_configuration_id = each.value.ip_configuration_id
  mode                = each.value.mode
  type                = each.value.type

  dynamic "external_mapping" {
    for_each = try(
      each.value.external_mappings, {}
    )

    content {
      address_space = external_mapping.value.address_space
      port_range    = external_mapping.value.port_range
    }
  }

  dynamic "internal_mapping" {
    for_each = try(
      each.value.internal_mappings, {}
    )

    content {
      address_space = internal_mapping.value.address_space
      port_range    = internal_mapping.value.port_range
    }
  }
}

# express route gateway
resource "azurerm_express_route_gateway" "er_gateway" {
  for_each = nonsensitive({
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "express_route_gateway", null
    ) != null
  })

  resource_group_name = coalesce(
    lookup(
      lookup(each.value, "express_route_gateway", {}), "resource_group_name", null
    ),
    lookup(
      var.vwan, "resource_group_name", null
    ),
    var.resource_group_name
  )

  location = coalesce(
    lookup(
      each.value, "location", null
    ), var.location
  )

  name = coalesce(
    each.value.express_route_gateway.name, try(
      join("-", [var.naming.express_route_gateway, each.key]), null
    ), each.key
  )

  virtual_hub_id                = azurerm_virtual_hub.vhub[each.key].id
  scale_units                   = each.value.express_route_gateway.scale_units
  allow_non_virtual_wan_traffic = each.value.express_route_gateway.allow_non_virtual_wan_traffic

  tags = coalesce(
    each.value.tags, var.tags
  )
}

# security partner provider
resource "azurerm_virtual_hub_security_partner_provider" "spp" {
  for_each = nonsensitive({
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "security_partner_provider", null
    ) != null
  })

  resource_group_name = coalesce(
    lookup(var.vwan, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(each.value, "location", null
    ), var.location
  )

  name                   = each.value.security_partner_provider.name
  virtual_hub_id         = azurerm_virtual_hub.vhub[each.key].id
  security_provider_name = each.value.security_partner_provider.security_provider_name

  tags = try(
    each.value.tags, var.tags
  )

  depends_on = [azurerm_vpn_gateway.vpn_gateway]
}

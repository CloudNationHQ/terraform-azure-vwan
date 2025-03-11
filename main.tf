# virtual wan
resource "azurerm_virtual_wan" "vwan" {
  name                              = var.vwan.name
  resource_group_name               = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location                          = coalesce(lookup(var.vwan, "location", null), var.location)
  allow_branch_to_branch_traffic    = try(var.vwan.allow_branch_to_branch_traffic, true)
  disable_vpn_encryption            = try(var.vwan.disable_vpn_encryption, false)
  type                              = try(var.vwan.type, "Standard")
  office365_local_breakout_category = try(var.vwan.office365_local_breakout_category, "None")

  tags = try(
    var.vwan.tags, var.tags
  )
}

# vhubs
resource "azurerm_virtual_hub" "vhub" {
  for_each = lookup(
    var.vwan, "vhubs", {}
  )

  name                                   = try(each.value.name, join("-", [var.naming.virtual_hub, each.key]))
  resource_group_name                    = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location                               = coalesce(lookup(each.value, "location", null), var.location)
  address_prefix                         = each.value.address_prefix
  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  sku                                    = try(each.value.sku, "Standard")
  hub_routing_preference                 = try(each.value.hub_routing_preference, "ExpressRoute")
  virtual_router_auto_scale_min_capacity = try(each.value.virtual_router_auto_scale_min_capacity, 2)

  tags = try(
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
  for_each = {
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "point_to_site_vpn", null
    ) != null
  }

  name                     = try(each.value.point_to_site_vpn.vpn_server_configuration_name, "p2s-vpn-config-${each.key}")
  resource_group_name      = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location                 = coalesce(lookup(each.value, "location", null), var.location)
  vpn_authentication_types = try(each.value.point_to_site_vpn.authentication_types, ["Certificate"])
  vpn_protocols            = try(each.value.point_to_site_vpn.protocols, ["IkeV2"])

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
  for_each = {
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "point_to_site_vpn", null
    ) != null
  }

  name                                = try(each.value.name, join("-", [var.naming.point_to_site_vpn_gateway, each.key]))
  resource_group_name                 = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location                            = coalesce(lookup(each.value, "location", null), var.location)
  virtual_hub_id                      = azurerm_virtual_hub.vhub[each.key].id
  vpn_server_configuration_id         = azurerm_vpn_server_configuration.p2s_config[each.key].id
  scale_unit                          = try(each.value.point_to_site_vpn.scale_unit, 1)
  routing_preference_internet_enabled = try(each.value.point_to_site_vpn.routing_preference_internet_enabled, false)
  dns_servers                         = try(each.value.point_to_site_vpn.dns_servers, [])
  tags                                = try(each.value.tags, var.tags)

  connection_configuration {
    name                      = try(each.value.point_to_site_vpn.connection_configuration_name, "p2s-connection-${each.key}")
    internet_security_enabled = try(each.value.point_to_site_vpn.internet_security_enabled, false)

    vpn_client_address_pool {
      address_prefixes = each.value.point_to_site_vpn.vpn_client_configuration.address_pool
    }

    dynamic "route" {
      for_each = try(each.value.point_to_site_vpn.route, null) != null ? [each.value.point_to_site_vpn.route] : []

      content {
        associated_route_table_id = route.value.associated_route_table_id
        inbound_route_map_id      = lookup(route.value, "inbound_route_map_id", null)
        outbound_route_map_id     = lookup(route.value, "outbound_route_map_id", null)

        dynamic "propagated_route_table" {
          for_each = try(route.value.propagated_route_table, null) != null ? [route.value.propagated_route_table] : []

          content {
            ids    = propagated_route_table.value.ids
            labels = try(propagated_route_table.value.labels, [])
          }
        }
      }
    }
  }
}

# site to site vpn gatewayP
resource "azurerm_vpn_gateway" "vpn_gateway" {
  for_each = {
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "site_to_site_vpn", null
    ) != null
  }

  name                                  = lookup(each.value.site_to_site_vpn, "name", null)
  resource_group_name                   = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location                              = coalesce(lookup(each.value, "location", null), var.location)
  virtual_hub_id                        = azurerm_virtual_hub.vhub[each.key].id
  routing_preference                    = lookup(each.value.site_to_site_vpn, "routing_preference", null)
  bgp_route_translation_for_nat_enabled = try(each.value.site_to_site_vpn.bgp_route_translation_for_nat_enabled, false)
  scale_unit                            = try(each.value.site_to_site_vpn.scale_unit, 1)

  tags = try(
    var.vwan.tags, var.tags
  )

  dynamic "bgp_settings" {
    for_each = try(each.value.bgp_settings, null) != null ? [each.value.bgp_settings] : []

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
  for_each = merge(flatten([
    for vhub_key, vhub in lookup(var.vwan, "vhubs", {}) : [
      for site_key, site in lookup(lookup(vhub, "site_to_site_vpn", {}), "vpn_sites", {}) : {
        "${vhub_key}-${site_key}" = merge(site, {
          vhub_key      = vhub_key
          site_key      = site_key
          vhub_location = lookup(vhub, "location", null)
        })
      }
    ]
  ])...)

  name                = try(each.value.name, join("-", [var.naming.vpn_site, "${each.value.vhub_key}-${each.value.site_key}"]))
  resource_group_name = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location            = coalesce(each.value.vhub_location, lookup(var.vwan, "location", null), var.location)
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_cidrs       = [each.value.address_prefix]
  device_vendor       = try(each.value.device_vendor, "Microsoft")
  device_model        = try(each.value.device_model, "VpnSite")

  tags = try(
    var.vwan.tags, var.tags
  )

  dynamic "o365_policy" {
    for_each = try(each.value.o365_policy, null) != null ? [each.value.o365_policy] : []

    content {
      dynamic "traffic_category" {
        for_each = try(each.value.o365_policy.traffic_category, null) != null ? [each.value.o365_policy.traffic_category] : []

        content {
          allow_endpoint_enabled    = try(traffic_category.value.allow_endpoint_enabled, false)
          default_endpoint_enabled  = try(traffic_category.value.default_endpoint_enabled, false)
          optimize_endpoint_enabled = try(traffic_category.value.optimize_endpoint_enabled, false)
        }
      }
    }
  }

  dynamic "link" {
    # Skip the conditional entirely and handle null values in the content block
    for_each = lookup(each.value, "vpn_links", { "link1" = {} })

    content {
      name          = link.key # fallback to name
      ip_address    = try(link.value.ip_address, each.value.gateway_ip)
      provider_name = try(link.value.provider_name, null)
      speed_in_mbps = try(link.value.speed_in_mbps, null)
      fqdn          = try(link.value.fqdn, null)

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
  for_each = merge(flatten([
    for vhub_key, vhub in lookup(var.vwan, "vhubs", {}) : [
      for site_key, site in lookup(lookup(vhub, "site_to_site_vpn", {}), "vpn_sites", {}) : [
        for conn_key, conn in lookup(site, "connections", {}) : {
          "${vhub_key}-${site_key}-${conn_key}" = merge(conn, {
            vhub_key = vhub_key
            site_key = site_key
            conn_key = conn_key
          })
        }
      ]
    ]
  ])...)

  name                      = try(each.value.name, join("-", [var.naming.vpn_gateway_connection, "${each.value.vhub_key}-${each.value.site_key}-${each.value.conn_key}"]))
  vpn_gateway_id            = azurerm_vpn_gateway.vpn_gateway[each.value.vhub_key].id
  remote_vpn_site_id        = azurerm_vpn_site.vpn_site["${each.value.vhub_key}-${each.value.site_key}"].id
  internet_security_enabled = try(each.value.internet_security_enabled, false)

  dynamic "vpn_link" {
    for_each = lookup(each.value, "vpn_links", {})

    content {
      name                                  = vpn_link.key
      vpn_site_link_id                      = one([for link in azurerm_vpn_site.vpn_site["${each.value.vhub_key}-${each.value.site_key}"].link : link.id if link.name == vpn_link.key])
      bgp_enabled                           = try(vpn_link.value.bgp_enabled, false)
      protocol                              = try(vpn_link.value.protocol, "IKEv2")
      shared_key                            = vpn_link.value.shared_key
      ingress_nat_rule_ids                  = try(vpn_link.value.ingress_nat_rule_ids, [])
      egress_nat_rule_ids                   = try(vpn_link.value.egress_nat_rule_ids, [])
      bandwidth_mbps                        = try(vpn_link.value.bandwidth_mbps, 10)
      connection_mode                       = try(vpn_link.value.connection_mode, "Default")
      local_azure_ip_address_enabled        = try(vpn_link.value.local_azure_ip_address_enabled, false)
      policy_based_traffic_selector_enabled = try(vpn_link.value.policy_based_traffic_selector_enabled, false)
      ratelimit_enabled                     = try(vpn_link.value.ratelimit_enabled, false)
      route_weight                          = try(vpn_link.value.route_weight, 0)

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

  routing {
    associated_route_table = azurerm_virtual_hub.vhub[each.value.vhub_key].default_route_table_id
    inbound_route_map_id   = try(each.value.inbound_route_map_id, null)
    outbound_route_map_id  = try(each.value.outbound_route_map_id, null)

    propagated_route_table {
      route_table_ids = [azurerm_virtual_hub.vhub[each.value.vhub_key].default_route_table_id]
      labels          = ["default"]
    }
  }

  traffic_selector_policy {
    local_address_ranges  = try(each.value.local_address_ranges, [])
    remote_address_ranges = try(each.value.remote_address_ranges, [])
  }
}

# vpn gateway nat rules
resource "azurerm_vpn_gateway_nat_rule" "nat_rule" {
  for_each = merge(flatten([
    for vhub_key, vhub in lookup(var.vwan, "vhubs", {}) : [
      for rule_key, rule in lookup(lookup(vhub, "site_to_site_vpn", {}), "nat_rules", {}) : {
        "${vhub_key}-${rule_key}" = merge(rule, {
          vhub_key = vhub_key
          rule_key = rule_key
        })
      }
    ]
  ])...)

  name                = coalesce(lookup(each.value, "name", null), each.value.rule_key)
  vpn_gateway_id      = azurerm_vpn_gateway.vpn_gateway[each.value.vhub_key].id
  ip_configuration_id = try(each.value.ip_configuration_id, null)
  mode                = try(each.value.mode, "EgressSnat")
  type                = try(each.value.type, "Static")

  dynamic "external_mapping" {
    for_each = try(each.value.external_mappings, {})
    content {
      address_space = external_mapping.value.address_space
      port_range    = try(external_mapping.value.port_range, null)
    }
  }

  dynamic "internal_mapping" {
    for_each = try(each.value.internal_mappings, {})
    content {
      address_space = internal_mapping.value.address_space
      port_range    = try(internal_mapping.value.port_range, null)
    }
  }
}

# express route gateway
resource "azurerm_express_route_gateway" "er_gateway" {
  for_each = {
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "express_route_gateway", null
    ) != null
  }

  name                          = try(each.value.express_route_gateway.name, join("-", [var.naming.express_route_gateway, each.key]))
  resource_group_name           = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location                      = coalesce(lookup(each.value, "location", null), var.location)
  virtual_hub_id                = azurerm_virtual_hub.vhub[each.key].id
  scale_units                   = each.value.express_route_gateway.scale_units
  allow_non_virtual_wan_traffic = try(each.value.express_route_gateway.allow_non_virtual_wan_traffic, false)
  tags                          = try(each.value.tags, var.tags)
}

# security partner provider
resource "azurerm_virtual_hub_security_partner_provider" "spp" {
  for_each = {
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(
      v, "security_partner_provider", null
    ) != null
  }

  name                   = each.value.security_partner_provider.name
  resource_group_name    = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location               = coalesce(lookup(each.value, "location", null), var.location)
  virtual_hub_id         = azurerm_virtual_hub.vhub[each.key].id
  security_provider_name = each.value.security_partner_provider.security_provider_name
  tags                   = try(each.value.tags, var.tags)

  depends_on = [azurerm_vpn_gateway.vpn_gateway]
}

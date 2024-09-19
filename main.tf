# virtual wan
resource "azurerm_virtual_wan" "vwan" {
  name                              = var.vwan.name
  resource_group_name               = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location                          = coalesce(lookup(var.vwan, "location", null), var.location)
  allow_branch_to_branch_traffic    = try(var.vwan.allow_branch_to_branch_traffic, true)
  disable_vpn_encryption            = try(var.vwan.disable_vpn_encryption, false)
  type                              = try(var.vwan.type, "Standard")
  office365_local_breakout_category = try(var.vwan.office365_local_breakout_category, "None")
  tags                              = try(var.vwan.tags, {})
}

# vhubs
resource "azurerm_virtual_hub" "vhub" {
  for_each = lookup(
    var.vwan, "vhubs", {}
  )

  name                   = try(each.value.name, join("-", [var.naming.virtual_hub, each.key]))
  resource_group_name    = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location               = coalesce(lookup(each.value, "location", null), var.location)
  address_prefix         = each.value.address_prefix
  virtual_wan_id         = azurerm_virtual_wan.vwan.id
  sku                    = try(each.value.sku, "Standard")
  hub_routing_preference = try(each.value.hub_routing_preference, "ExpressRoute")
  tags                   = try(each.value.tags, {})
}

# vpn gateway
resource "azurerm_vpn_gateway" "vpn_gateway" {
  for_each = {
    for k, v in lookup(var.vwan, "vhubs", {}) : k => v
    if lookup(v, "vpn_gateway", null) != null
  }
  name                = lookup(each.value.vpn_gateway, "name", null)
  resource_group_name = coalesce(lookup(var.vwan, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(each.value, "location", null), var.location)
  virtual_hub_id      = azurerm_virtual_hub.vhub[each.key].id
  routing_preference  = lookup(each.value.vpn_gateway, "routing_preference", null)
  tags                = try(var.vwan.tags, {})
}

# vpn sites
resource "azurerm_vpn_site" "vpn_site" {
  for_each = merge(flatten([
    for vhub_key, vhub in lookup(var.vwan, "vhubs", {}) : [
      for site_key, site in lookup(lookup(vhub, "vpn_gateway", {}), "vpn_sites", {}) : {
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
  tags                = try(var.vwan.tags, {})

  dynamic "link" {
    # minimal of one link is required
    for_each = length(lookup(each.value, "vpn_links", {})) > 0 ? each.value.vpn_links : { "default" = {} }
    content {
      name          = link.key
      ip_address    = try(link.value.ip_address, each.value.gateway_ip)
      provider_name = try(link.value.provider_name, null)
      speed_in_mbps = try(link.value.speed_in_mbps, null)
    }
  }
}

# vpn gateway connections
resource "azurerm_vpn_gateway_connection" "vpn_connection" {
  for_each = merge(flatten([
    for vhub_key, vhub in lookup(var.vwan, "vhubs", {}) : [
      for site_key, site in lookup(lookup(vhub, "vpn_gateway", {}), "vpn_sites", {}) : [
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

  name               = try(each.value.name, join("-", [var.naming.vpn_gateway_connection, "${each.value.vhub_key}-${each.value.site_key}-${each.value.conn_key}"]))
  vpn_gateway_id     = azurerm_vpn_gateway.vpn_gateway[each.value.vhub_key].id
  remote_vpn_site_id = azurerm_vpn_site.vpn_site["${each.value.vhub_key}-${each.value.site_key}"].id

  dynamic "vpn_link" {
    for_each = lookup(each.value, "vpn_links", {})

    content {
      name                 = vpn_link.key
      vpn_site_link_id     = one([for link in azurerm_vpn_site.vpn_site["${each.value.vhub_key}-${each.value.site_key}"].link : link.id if link.name == vpn_link.key])
      bgp_enabled          = try(vpn_link.value.bgp_enabled, false)
      protocol             = try(vpn_link.value.protocol, "IKEv2")
      shared_key           = vpn_link.value.shared_key
      ingress_nat_rule_ids = try(vpn_link.value.ingress_nat_rule_ids, [])
      egress_nat_rule_ids  = try(vpn_link.value.egress_nat_rule_ids, [])
    }
  }

  routing {
    associated_route_table = azurerm_virtual_hub.vhub[each.value.vhub_key].default_route_table_id

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

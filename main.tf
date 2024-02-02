# virtual wan
resource "azurerm_virtual_wan" "vwan" {
  name                           = try(var.vwan.name, var.naming.virtual_wan)
  location                       = var.location
  resource_group_name            = var.resourcegroup
  allow_branch_to_branch_traffic = try(var.vwan.allow_branch_to_branch_traffic, true)
  disable_vpn_encryption         = try(var.vwan.disable_vpn_encryption, false)
  type                           = try(var.vwan.type, "Standard")
  tags                           = try(var.vwan.tags, {})

  office365_local_breakout_category = try(var.vwan.office365_local_breakout_category, "None")
}

# vhubs
resource "azurerm_virtual_hub" "vhub" {
  for_each = local.vhubs

  name                   = each.value.name
  location               = each.value.location
  resource_group_name    = each.value.resourcegroup
  address_prefix         = each.value.address_prefix
  virtual_wan_id         = azurerm_virtual_wan.vwan.id
  sku                    = each.value.sku
  hub_routing_preference = each.value.hub_routing_preference
  tags                   = each.value.tags
}

# firewalls
resource "azurerm_firewall" "fw" {
  for_each = {
    for fw_key, fw in local.firewalls : fw_key => fw
  }

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resourcegroup
  sku_tier            = each.value.tier
  sku_name            = each.value.sku
  tags                = each.value.tags
  firewall_policy_id  = each.value.associate_policy ? azurerm_firewall_policy.fwp[each.key].id : null

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub[each.key].id
    public_ip_count = each.value.public_ip_count
  }
}

# firewall Policies
resource "azurerm_firewall_policy" "fwp" {
  for_each = {
    for fwp_key, fwp in local.firewall_policies : fwp_key => fwp
  }

  name                              = each.value.name
  location                          = each.value.location
  resource_group_name               = each.value.resourcegroup
  tags                              = each.value.tags
  base_policy_id                    = each.value.base_policy_id
  private_ip_ranges                 = each.value.private_ip_ranges
  sku                               = each.value.sku
  sql_redirect_allowed              = each.value.sql_redirect_allowed
  threat_intelligence_mode          = each.value.threat_intelligence_mode
  auto_learn_private_ranges_enabled = each.value.auto_learn_private_ranges_enabled

  dynamic "dns" {
    for_each = each.value.dns != null ? [each.value.dns] : []
    content {
      proxy_enabled = dns.value.proxy_enabled
      servers       = dns.value.servers
    }
  }

  dynamic "intrusion_detection" {
    for_each = lookup(each.value, "intrusion_detection", null) != null ? [each.value.intrusion_detection] : []

    content {
      mode = intrusion_detection.value.mode

      dynamic "traffic_bypass" {
        for_each = lookup(intrusion_detection.value, "traffic_bypass", {})

        content {
          name                  = traffic_bypass.key
          protocol              = traffic_bypass.value.protocol
          description           = lookup(traffic_bypass.value, "description", null)
          destination_addresses = lookup(traffic_bypass.value, "destination_addresses", [])
          destination_ip_groups = lookup(traffic_bypass.value, "destination_ip_groups", [])
          destination_ports     = lookup(traffic_bypass.value, "destination_ports", [])
          source_addresses      = lookup(traffic_bypass.value, "source_addresses", [])
          source_ip_groups      = lookup(traffic_bypass.value, "source_ip_groups", [])
        }
      }
      dynamic "signature_overrides" {
        for_each = lookup(intrusion_detection.value, "signature_overrides", {})

        content {
          id    = signature_overrides.value.id
          state = signature_overrides.value.state
        }
      }
    }
  }
}

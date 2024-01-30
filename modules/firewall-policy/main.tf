# firewall policy
resource "azurerm_firewall_policy" "policy" {
  for_each = try(var.policy, {})

  name                              = each.value.name
  location                          = var.location
  resource_group_name               = var.resourcegroup
  tags                              = try(each.value.tags, {})
  private_ip_ranges                 = try(each.value.private_ip_ranges, null)
  sku                               = try(each.value.sku, "Standard")
  sql_redirect_allowed              = try(each.value.sql_redirect_allowed, null)
  threat_intelligence_mode          = try(each.value.threat_intelligence_mode, "Alert")
  auto_learn_private_ranges_enabled = try(each.value.auto_learn_private_ranges_enabled, null)

  dynamic "dns" {
    for_each = lookup(each.value, "dns", null) != null ? [each.value.dns] : []

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

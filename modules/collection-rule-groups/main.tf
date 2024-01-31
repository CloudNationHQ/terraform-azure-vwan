# ip groups
resource "azurerm_ip_group" "ipgroup" {
  for_each = try(var.ip_groups, {})

  name                = try(each.value.name, join("-", [var.naming.ip_group, each.key]))
  location            = var.location
  resource_group_name = var.resourcegroup

  lifecycle {
    ignore_changes = [cidrs]
  }
}

# ip group cidrs
resource "azurerm_ip_group_cidr" "ipcidr" {
  for_each = local.flattened_ip_groups

  ip_group_id = azurerm_ip_group.ipgroup[each.value.group].id
  cidr        = each.value.cidr
}

# collection groups
resource "azurerm_firewall_policy_rule_collection_group" "group" {
  for_each = var.groups

  name               = try(each.value.name, format("fwrcg-%s", each.key))
  firewall_policy_id = try(var.groups[each.key].firewall_policy_id, null)
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = toset(
      try(each.value.network_rule_collections, [])
    )

    content {
      name     = try(network_rule_collection.value.name, format("nrc-%s", network_rule_collection.value.key))
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = try(rule.value.name, rule.key)
          description           = try(rule.value.description, null)
          protocols             = rule.value.protocols
          destination_ports     = rule.value.destination_ports
          destination_addresses = try(rule.value.destination_addresses, null)
          destination_ip_groups = try(rule.value.destination_ip_groups, null)
          destination_fqdns     = try(rule.value.destination_fqdns, null)
          source_addresses      = try(rule.value.source_addresses, null)
          source_ip_groups      = try(rule.value.source_ip_groups, null)
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = toset(
      try(each.value.application_rule_collections, [])
    )

    content {
      name     = try(application_rule_collection.value.name, format("arc-%s", application_rule_collection.value.key))
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules


        content {
          name                  = try(rule.value.name, rule.key)
          description           = try(rule.value.description, null)
          source_addresses      = try(rule.value.source_addresses, null)
          source_ip_groups      = try(rule.value.source_ip_groups, null)
          destination_addresses = try(rule.value.destination_addresses, null)
          destination_urls      = try(rule.value.destination_urls, null)
          destination_fqdns     = try(rule.value.destination_fqdns, null)
          destination_fqdn_tags = try(rule.value.destination_fqdn_tags, null)
          terminate_tls         = try(rule.value.terminate_tls, null)
          web_categories        = try(rule.value.web_categories, null)

          dynamic "protocols" {
            for_each = rule.value.protocols

            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = toset(
      try(each.value.nat_rule_collections, [])
    )

    content {
      name     = try(nate_rule_collection.value.name, format("nrc-%s", nat_rule_collection.value.key))
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules

        content {
          name                = try(rule.value.name, rule.key)
          description         = try(rule.value.description, null)
          protocols           = rule.value.protocols
          source_addresses    = try(rule.value.source_addresses, null)
          source_ip_groups    = try(rule.value.source_ip_groups, null)
          destination_address = try(rule.value.destination_address, null)
          destination_ports   = try(rule.value.destination_ports, null)
          translated_address  = try(rule.value.translated_address, null)
          translated_fqdn     = try(rule.value.translated_fqdn, null)
          translated_port     = try(rule.value.translated_port, null)
        }
      }
    }
  }
}

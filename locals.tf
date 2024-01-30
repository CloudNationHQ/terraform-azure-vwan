locals {
  firewalls = {
    for fw_key, fw in var.vwan.vhubs : fw_key => {

      name             = try(fw.firewall_name, join("-", [var.naming.firewall, fw_key]))
      location         = try(fw.location, var.location)
      resourcegroup    = try(fw.resourcegroup, var.resourcegroup)
      tier             = try(fw.firewall_tier, "Standard")
      sku              = try(fw.firewall_sku, "AZFW_Hub")
      tags             = try(fw.tags, {})
      public_ip_count  = try(fw.firewall_public_ip_count, 1)
      associate_policy = try(fw.associate_policy, true)
    }
  }
}

locals {
  vhubs = {
    for vh_key, vh in var.vwan.vhubs : vh_key => {

      name                   = try(vh.name, join("-", [var.naming.virtual_hub, vh_key]))
      location               = try(vh.location, var.location)
      resourcegroup          = try(vh.resourcegroup, var.resourcegroup)
      address_prefix         = vh.address_prefix
      sku                    = try(vh.sku, "Standard")
      hub_routing_preference = try(vh.hub_routing_preference, "ExpressRoute")
      tags                   = try(vh.tags, {})
    }
  }
}

locals {
  firewall_policies = {
    for fwp_key, fwp in var.vwan.vhubs : fwp_key => {

      name                              = try(fwp.policy.name, join("-", [var.naming.firewall_policy, fwp_key]))
      base_policy_id                    = try(fwp.policy.base_policy_id, null)
      location                          = try(fwp.policy.location, var.location)
      resourcegroup                     = try(fwp.resourcegroup, var.resourcegroup)
      dns                               = try(fwp.policy.dns, null)
      intrusion_detection               = try(fwp.policy.intrusion_detection, null)
      tags                              = try(fwp.tags, {})
      private_ip_ranges                 = try(fwp.policy.private_ip_ranges, null)
      sku                               = try(fwp.policy.sku, "Standard")
      sql_redirect_allowed              = try(fwp.policy.sql_redirect_allowed, null)
      threat_intelligence_mode          = try(fwp.policy.threat_intelligence_mode, "Alert")
      auto_learn_private_ranges_enabled = try(fwp.policy.auto_learn_private_ranges_enabled, null)
    }
  }
}

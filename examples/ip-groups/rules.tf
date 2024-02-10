locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["virtual_wan", "firewall", "firewall_policy", "ip_group"]
}

locals {
  collection_rule_groups = {
    default = {
      name               = "EnhancedSecurityRuleCollectionGroup"
      priority           = 200
      firewall_policy_id = module.fwpolicy.policy.parent.id
      network_rule_collections = {
        CorporateWebAccessRules = {
          priority = 100
          action   = "Allow"
          rules = {
            allowHttpHttps = {
              name                  = "AllowHTTPandHTTPS"
              protocols             = ["TCP"]
              destination_ports     = ["80", "443"]
              source_ip_groups      = [module.ip_groups.groups.internal-networks.id]
              destination_addresses = ["*"]
            }
            allowVpnAccess = {
              name                  = "AllowVPNAccess"
              protocols             = ["UDP"]
              destination_ports     = ["1194", "500", "4500"]
              source_ip_groups      = [module.ip_groups.groups.remote-workers.id]
              destination_addresses = ["*"]
            }
            allowCorporateEmail = {
              name                  = "AllowCorporateEmail"
              protocols             = ["TCP"]
              destination_ports     = ["993", "587"]
              destination_ip_groups = [module.ip_groups.groups.email-server.id]
              source_addresses      = ["*"]
            }
            allowRemoteDesktop = {
              name                  = "AllowRemoteDesktop"
              protocols             = ["TCP"]
              destination_ports     = ["3389"]
              source_ip_groups      = [module.ip_groups.groups.remote-workers.id]
              destination_addresses = ["*"]
            }
          }
        }
        RestrictedAccessRules = {
          priority = 150
          action   = "Deny"
          rules = {
            denyTorExitNodes = {
              name                  = "DenyTorExitNodes"
              protocols             = ["Any"]
              destination_ports     = ["*"]
              source_ip_groups      = [module.ip_groups.groups.tor-exit-nodes.id]
              destination_addresses = ["*"]
            }
            denyKnownMalicious = {
              name                  = "DenyKnownMaliciousIPs"
              protocols             = ["Any"]
              destination_ports     = ["*"]
              source_ip_groups      = [module.ip_groups.groups.known-malicious.id]
              destination_addresses = ["*"]
            }
          }
        }
        InterSiteTrafficRules = {
          priority = 250
          action   = "Allow"
          rules = {
            allowSiteToSite = {
              name                  = "AllowSiteToSite"
              protocols             = ["TCP", "UDP"]
              destination_ports     = ["*"]
              source_ip_groups      = [module.ip_groups.groups.site-a.id]
              destination_ip_groups = [module.ip_groups.groups.site-b.id]
            }
            allowBackupServices = {
              name                  = "AllowBackupServices"
              protocols             = ["TCP"]
              destination_ports     = ["443"]
              source_ip_groups      = [module.ip_groups.groups.all-sites.id]
              destination_ip_groups = [module.ip_groups.groups.backup-services.id]
            }
          }
        }
      }
    }
  }
}

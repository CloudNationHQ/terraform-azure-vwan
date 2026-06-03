locals {
  vhubs = {
    weu = {
      location       = "westeurope"
      address_prefix = "10.0.0.0/23"

      site_to_site_vpn = {
        name = "weu-s2s-gateway"

        # Gateway-level BGP configuration.
        # custom_ips contains only the Azure-side APIPA addresses, one per gateway instance.
        # On-premise APIPA addresses are set per VPN site link via bgp.peering_address below.
        bgp_settings = {
          asn         = 65515
          peer_weight = 0
          instance_0_bgp_peering_address = {
            custom_ips = ["169.254.21.1"]
          }
          instance_1_bgp_peering_address = {
            custom_ips = ["169.254.22.1"]
          }
        }

        vpn_sites = {
          # On-premise datacenter 1
          # One link per physical device — Azure creates two tunnels automatically
          dc1 = {
            address_cidrs = ["192.168.1.0/24"]
            vpn_links = {
              link1 = {
                ip_address    = "203.0.113.1"
                provider_name = "ISP1"
                speed_in_mbps = 100
                bgp = {
                  peering_address = "169.254.21.2"
                  asn             = 64512
                }
              }
            }
            connections = {
              connection1 = {
                vpn_links = {
                  link1 = {
                    shared_key  = module.kv.secrets.psk.value
                    bgp_enabled = true
                    protocol    = "IKEv2"
                  }
                }
              }
            }
          }

          # On-premise datacenter 2
          dc2 = {
            address_cidrs = ["192.168.2.0/24"]
            vpn_links = {
              link1 = {
                ip_address    = "203.0.114.1"
                provider_name = "ISP1"
                speed_in_mbps = 100
                bgp = {
                  peering_address = "169.254.21.6"
                  asn             = 64513
                }
              }
            }
            connections = {
              connection1 = {
                vpn_links = {
                  link1 = {
                    shared_key  = module.kv.secrets.psk.value
                    bgp_enabled = true
                    protocol    = "IKEv2"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

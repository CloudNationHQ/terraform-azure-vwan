output "policy" {
  description = "contains firewall policy configuration"
  value = {
    for k, policy in azurerm_firewall_policy.fwp : k => policy
  }
}

output "firewall_public_ip_addresses" {
  description = "list of public ip addresses associated with the firewall"
  value = {
    public_ip_addresses = [
      for key, fw in azurerm_firewall.fw :
      fw.virtual_hub[0].public_ip_addresses[0]
    ]
  }
}

output "firewall" {
  description = "contains firewall configuration"
  value       = azurerm_firewall.fw
}

output "vhub" {
  description = "contains virtual hub configuration"
  value       = azurerm_virtual_hub.vhub
}

output "vwan" {
  description = "contains virtual wan configuration"
  value       = azurerm_virtual_wan.vwan
}

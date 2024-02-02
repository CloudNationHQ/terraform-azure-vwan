output "policy" {
  description = "contains all firewall policy configuration"
  value = {
    for k, policy in azurerm_firewall_policy.policy : k => policy
  }
}

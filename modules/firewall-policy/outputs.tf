output "policy" {
  value = {
    for k, policy in azurerm_firewall_policy.policy : k => policy
  }
}

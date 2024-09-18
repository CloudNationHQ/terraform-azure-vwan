output "vwan" {
  description = "contains virtual wan configuration"
  value       = azurerm_virtual_wan.vwan
}

output "vhubs" {
  description = "contains virtual hub configuration"
  value       = azurerm_virtual_hub.vhub
}

output "vwan" {
  description = "contains virtual wan configuration"
  value       = var.vwan.use_existing_vwan ? data.azurerm_virtual_wan.existing_vwan["vwan"] : azurerm_virtual_wan.vwan["vwan"]
}

output "vhubs" {
  description = "contains virtual hub configuration"
  value       = azurerm_virtual_hub.vhub
}

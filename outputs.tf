output "vwan" {
  description = "contains virtual wan configuration"
  value       = var.vwan.use_existing_vwan ? data.azurerm_virtual_wan.this["this"] : azurerm_virtual_wan.this["this"]
}

output "vhubs" {
  description = "contains virtual hub configuration"
  value       = azurerm_virtual_hub.this
}

output "vpn_server_configurations" {
  description = "contains vpn server configuration"
  value       = azurerm_vpn_server_configuration.this
}

output "point_to_site_vpn_gateways" {
  description = "contains point to site vpn gateway configuration"
  value       = azurerm_point_to_site_vpn_gateway.this
}

output "vpn_gateways" {
  description = "contains vpn gateway configuration"
  value       = azurerm_vpn_gateway.this
}

output "vpn_sites" {
  description = "contains vpn site configuration"
  value       = azurerm_vpn_site.this
}

output "vpn_gateway_connections" {
  description = "contains vpn gateway connection configuration"
  value       = azurerm_vpn_gateway_connection.this
}

output "vpn_gateway_nat_rules" {
  description = "contains vpn gateway nat rule configuration"
  value       = azurerm_vpn_gateway_nat_rule.this
}

output "express_route_gateways" {
  description = "contains express route gateway configuration"
  value       = azurerm_express_route_gateway.this
}

output "security_partner_providers" {
  description = "contains security partner provider configuration"
  value       = azurerm_virtual_hub_security_partner_provider.this
}

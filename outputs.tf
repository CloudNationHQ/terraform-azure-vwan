output "vwan" {
  description = "contains virtual wan configuration"
  value       = var.vwan.use_existing_vwan ? data.azurerm_virtual_wan.existing_vwan["vwan"] : azurerm_virtual_wan.vwan["vwan"]
}

output "vhubs" {
  description = "contains virtual hub configuration"
  value       = azurerm_virtual_hub.vhub
}

output "vpn_server_configurations" {
  description = "contains vpn server configuration"
  value       = azurerm_vpn_server_configuration.p2s_config
}

output "point_to_site_vpn_gateways" {
  description = "contains point to site vpn gateway configuration"
  value       = azurerm_point_to_site_vpn_gateway.p2s_gateway
}

output "vpn_gateways" {
  description = "contains vpn gateway configuration"
  value       = azurerm_vpn_gateway.vpn_gateway
}

output "vpn_sites" {
  description = "contains vpn site configuration"
  value       = azurerm_vpn_site.vpn_site
}

output "vpn_gateway_connections" {
  description = "contains vpn gateway connection configuration"
  value       = azurerm_vpn_gateway_connection.vpn_connection
}

output "vpn_gateway_nat_rules" {
  description = "contains vpn gateway nat rule configuration"
  value       = azurerm_vpn_gateway_nat_rule.nat_rule
}

output "express_route_gateways" {
  description = "contains express route gateway configuration"
  value       = azurerm_express_route_gateway.er_gateway
}

output "security_partner_providers" {
  description = "contains security partner provider configuration"
  value       = azurerm_virtual_hub_security_partner_provider.spp
}

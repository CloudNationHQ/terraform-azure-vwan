moved {
  from = azurerm_virtual_wan.vwan["vwan"]
  to   = azurerm_virtual_wan.this["this"]
}

moved {
  from = azurerm_virtual_hub.vhub
  to   = azurerm_virtual_hub.this
}

moved {
  from = azurerm_vpn_server_configuration.p2s_config
  to   = azurerm_vpn_server_configuration.this
}

moved {
  from = azurerm_point_to_site_vpn_gateway.p2s_gateway
  to   = azurerm_point_to_site_vpn_gateway.this
}

moved {
  from = azurerm_vpn_gateway.vpn_gateway
  to   = azurerm_vpn_gateway.this
}

moved {
  from = azurerm_vpn_site.vpn_site
  to   = azurerm_vpn_site.this
}

moved {
  from = azurerm_vpn_gateway_connection.vpn_connection
  to   = azurerm_vpn_gateway_connection.this
}

moved {
  from = azurerm_vpn_gateway_nat_rule.nat_rule
  to   = azurerm_vpn_gateway_nat_rule.this
}

moved {
  from = azurerm_express_route_gateway.er_gateway
  to   = azurerm_express_route_gateway.this
}

moved {
  from = azurerm_virtual_hub_security_partner_provider.spp
  to   = azurerm_virtual_hub_security_partner_provider.this
}

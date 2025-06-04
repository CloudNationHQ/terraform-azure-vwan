# Vhub Connection

This submodule illustrates how to manage vhub connections

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_virtual_hub_connection.vcon](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection) (resource)
- [azurerm_virtual_hub.vhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_hub) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_virtual_hub"></a> [virtual\_hub](#input\_virtual\_hub)

Description: Contains all virtual hub connection configurations.

Type:

```hcl
object({
    name                = string
    resource_group_name = string
    connections = optional(map(object({
      name                      = optional(string, null)
      remote_virtual_network_id = string
      internet_security_enabled = optional(bool, true)
      routing = optional(object({
        outbound_route_map_id                       = optional(string, null)
        inbound_route_map_id                        = optional(string, null)
        associated_route_table_id                   = optional(string, null)
        static_vnet_local_route_override_criteria   = optional(string, null)
        static_vnet_propagate_static_routes_enabled = optional(bool, true)
        propagated_route_table = optional(object({
          labels          = optional(list(string), null)
          route_table_ids = optional(list(string), [])
        }), null)
        static_vnet_route = optional(map(object({
          name                = optional(string, null)
          address_prefixes    = optional(list(string), null)
          next_hop_ip_address = optional(string, null)
        })), {})
      }), null)
    })), {})
  })
```

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

# Vhub Route Table

This submodule illustrates how to manage vhub route tables

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

- [azurerm_virtual_hub_route_table.rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_route_table) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables)

Description: contains all virtual hub route tables configurations

Type:

```hcl
map(object({
    virtual_hub_id = string
    name           = optional(string)
    labels         = list(string)
    routes = map(object({
      name              = optional(string)
      destinations_type = string
      destinations      = list(string)
      next_hop_type     = string
      next_hop          = string
    }))
  }))
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_naming"></a> [naming](#input\_naming)

Description: Used for naming purposes

Type: `map(string)`

Default: `{}`

## Outputs

No outputs.
<!-- END_TF_DOCS -->

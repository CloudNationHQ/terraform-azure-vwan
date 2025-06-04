# Routing Intent

This submodule illustrates how to manage routing intents.

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

- [azurerm_virtual_hub_routing_intent.routing_intent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_routing_intent) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_configs"></a> [configs](#input\_configs)

Description: Contains all routing intent configurations.

Type:

```hcl
map(object({
    name           = optional(string, null)
    virtual_hub_id = string
    routing_policies = map(object({
      destinations = list(string)
      next_hop     = string
    }))
  }))
```

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

# Routing Intents

This deploys routing intents on the virtual hub

```hcl
configs = map(object({
  name           = string
  virtual_hub_id = string
  routing_policies = map(object({
    destinations = list(string)
    next_hop     = string
  }))
}))
```

variable "configs" {
  description = "the configurations for the routing intents."
  type        = any
}

variable "resource_group" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}

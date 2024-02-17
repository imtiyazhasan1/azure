variable "client_id" {
  type    = string
}

variable "client_secret" {
  type    = string
}

variable "tenant_id" {
  type    = string
}

variable "subscription_id" {
  type    = string
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet_id_1", "subnet_id_2"]
}

variable "vnet_name" {
  type    = string
  default = "aks_qatar_ipay_dev_vnet"
}

variable "app_pool_min_size" {
  type    = number
  default = 2
}

variable "app_pool_max_size" {
  type    = number
  default = 10
}

variable "tags" {
  type    = map(string)
  default = {
    Environment         = "Production"
    "support team"      = "Qatar Cloud Team"
    "maintenance window" = "10PM to 00:30 AM on Monday"
  }
}

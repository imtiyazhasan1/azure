variable "rg" {
  default = null
  type = string
  description = "provide the resourceGroup name.  To create or to use existing, this is required"
}
variable "region" {
  default = null
  type = string
  description = "provide the azure location name here"
}
variable "createrg" {
  type = bool
  default = false
  description = "provide the value true if wants to create new RG or false if wants to use existing one"
}
variable "nsg_name" {
  default = ""
  description = "provide NSG name to create and attach at the subnet level"
}
variable "network_name" {
  default = ""
  description = "Provide Vnet name to create"
}
variable "network_cidr" {
  default = [ "192.168.0.0/16" ]
  description = "Provide CIDR for VNET. "
  type = list(string)
}
variable "tags" {
  type = map
  description = "provide the tags in map"
  default = {
    name = "myvnet"
    owner = "test"
  }
}
variable "subnets" {
  type = map(object({
    name = string
    cidr = string
    nsg_name = string 
  }))
}

variable "nsg_rule" {
  type = map(object({
    name                       = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    priority                   = number
  }))
}
variable "nsg_enable" {
  default = true
  type = bool
  description = "Mention if you want  NSG to be enabled and attached with all subnets"
}
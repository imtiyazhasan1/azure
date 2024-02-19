resource "azurerm_resource_group" "this" {
  count    = var.createrg ? 1 : 0
  name     = var.rg
  location = var.region
}
data "azurerm_resource_group" "this" {
  name  = var.rg
  count = var.createrg ? 0 : 1
}
resource "azurerm_network_security_group" "this" {
  count               = var.nsg_enable == true ? 1 : 0
  name                = var.nsg_name
  location            = var.region
  resource_group_name = var.createrg ? azurerm_resource_group.this[0].name : data.azurerm_resource_group.this[0].name
  dynamic "security_rule" {
    for_each = var.nsg_rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_virtual_network" "main" {
  name                = var.network_name
  location            = var.region
  resource_group_name = var.createrg ? azurerm_resource_group.this[0].name : data.azurerm_resource_group.this[0].name
  address_space       = var.network_cidr

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.cidr
      security_group = var.nsg_enable ? azurerm_network_security_group.this[0].name : null
    }
  }
  tags = var.tags

}
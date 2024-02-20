# VNET Module with aks module to  use

### example to use -
```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}

provider "azurerm" {
    features {}
}
module "firstvnet" {
  source = "./mod/vnet"
  network_name = "devvnet"
  rg = "testrg"
  region = "eastus"
  createrg = true
  network_cidr = [ "192.168.0.0/16" ]
  subnets = {
    devsubnet = {
        name = "devsubnet-a"
        cidr = "192.168.0.0/24"
        nsg_name = "mynsg"
    },
    prodsubnet = {
        name = "prodsubnet-a"
        cidr = "192.168.2.0/24"
        nsg_name = "mynsg"
    }
  }
  nsg_name = "mynsg"
  nsg_rule = {
    http = {
        name                       = "http"
        protocol                   = "Tcp"
        source_port_range          = "80"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        priority                   = 100
    },
    https = {
        name                       = "https"
        protocol                   = "Tcp"
        source_port_range          = "443"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        priority                   = 101
    },
    ssh = {
        name                       = "ssh"
        protocol                   = "Tcp"
        source_port_range          = "22"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        priority                   = 102
    }
  }
}

module "myaks" {
  source               = "./mod/aks"
  name                 = "myaks"
  location             = "westeurope"
  resource_group       = "myaksrg"
  kubernetes_version   = "1.27.5"
  private_enabled      = false
  network_plugin       = "kubenet"
  client_id            = ""
  client_secret        = ""
  linux_admin_username = "vijay"
  linux_ssh_key        = file("aks.pub)
  rbac_enabled         = true
  cluster_subnet_id    = module.firstvnet.vnet_subnet_id[0] 
}
```
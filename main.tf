terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}
module "firstvnet" {
  source       = "./mod/vnet"
  network_name = "devvnet"
  rg           = "testrg"
  region       = "eastus"
  createrg     = true
  nsg_enable   = true
  network_cidr = ["192.168.0.0/16"]
  subnets = {
    devsubnet = {
      name     = "devsubnet-a"
      cidr     = "192.168.0.0/24"
      nsg_name = "mynsg"
    },
    prodsubnet = {
      name     = "prodsubnet-a"
      cidr     = "192.168.2.0/24"
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
  linux_ssh_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKH/Ri7zAJR5sZuxCH7Dser/z667UuAKmzlDrLsWTTybDZ9+Ob7Mzyj9/c03qM/6H5V4k4LaVAy2lw+giFwNDC7zKwpNbSB1Hw7g0gEW23jjRWmB1hUeoN4ciXIKLlj2QrfldBLZzFd2PULIXd4eByf41IjMqgHDT4dwnPVxoJVj/xA5aNxgcwnNaLHuawiqDL/e3oVLomw/BupYkwuRSUR7I0hN+1GjekxiuANWmdAeRudByN4bfjc/Kybd/fX/MsIuJQ8hxxnL8V/yK2HWuBBf1WmnGxIFTS83OXVZgods3wLu2zTVwCanzU666f4lkHcw7MF5Sj1UwGDly8m7aytLQt+Lx5IR2WD5vcUOxtzCsTh1Cx78wZsSWycoJJaf+PsRzoB+fY1Kz5FelI5W8wXb0RwrZPS2ByLiGGSVEmIvp9p35mPdFgzx28C5N5vHcp6DrZpfXPbPqQU5zAk6mP/YJoc7BZVU0vrIx4eeXTjOhvMP+ZjMXtLibTzYP6BHsSDqBDi1XTv9CbGH4B9IVegL9X4wgy7Dcxpxay/PkFEkao9VaH9Zd6rFXNTYgpnfyZ1Fsf9o603Bmi/tVRiUcDtMhdq9P/WlRx5FDLylfgFNb2plSGOCjPs/RJjy7hakll82ligj/f91Xw6pj+gooOPY3uDtS2TlqFYRsldLtoaw== sergio@MacBook-Pro.home"
  rbac_enabled         = true
  cluster_subnet_id    = module.firstvnet.vnet_subnet_id[0] 
}
provider "azurerm" {
  features {
    key_vault_references         = true
    virtual_machine_extension_images = true
    role_based_access_control    = true
    advanced_filtering           = true
    network_policy               = true
  }

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

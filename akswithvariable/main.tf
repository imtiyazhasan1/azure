# Define the AKS cluster
resource "azurerm_kubernetes_cluster" "aks_qatar_ipay_dev" {
  name                = "aks_qatar_ipay_dev"
  location            = azurerm_resource_group.aks_qatar_ipay_dev_rg.location
  resource_group_name = azurerm_resource_group.aks_qatar_ipay_dev_rg.name
  dns_prefix          = "aks-qatar-ipay-dev"
  kubernetes_version  = "1.27.0"
  auto_upgrade_channel = "None"  # Disable automatic upgrades
  sku_tier            = "Paid"  # Specify the pricing tier

  node_security_baseline {
    type = "NodeImage"  # Set the node security baseline type to Node Image
  }

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 50
    node_image_id   = "/subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.Compute/images/<image_name>"

    vnet_subnet_id = azurerm_subnet.aks_qatar_ipay_dev_subnet1.id
  }

  node_pool "app_pool" {
    name            = "app-pool"
    node_count      = var.app_pool_min_size
    min_count       = var.app_pool_min_size
    max_count       = var.app_pool_max_size
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 50

    vnet_subnet_ids = var.subnet_ids

    pod_cidr = "192.168.0.0/16"

    node_labels = {
      "app" = "app-node"
    }

    taint {
      key    = "app"
      value  = "true"
      effect = "NoSchedule"
    }

    tolerations {
      key      = "app"
      operator = "Equal"
      value    = "true"
      effect   = "NoSchedule"
    }
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = "10.2.0.10"
    service_cidr       = "10.2.0.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  tags = var.tags
}

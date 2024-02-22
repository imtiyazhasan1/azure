locals {
  dns_service_ip = cidrhost(var.vnet_service_cidr, 2)
  oms_enabled    = var.oms_log_analytics_workspace_id != null
}

resource "azurerm_kubernetes_cluster" "main" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group
  dns_prefix                        = var.dns_prefix
  kubernetes_version                = var.kubernetes_version
  node_resource_group               = var.node_resource_group
  private_cluster_enabled           = var.private_enabled
  role_based_access_control_enabled = var.rbac_enabled
  sku_tier                          = var.sku
  http_application_routing_enabled  = var.http_application_routing_enabled
 identity {
   type = "SystemAssigned"
 }
  
  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }
  azure_active_directory_role_based_access_control {
    managed                = var.is_managed_ad
    azure_rbac_enabled     = var.is_managed_ad ? var.rbac_enabled : null
    admin_group_object_ids = var.is_managed_ad ? var.rbac_aad_admin : null
    client_app_id          = var.is_managed_ad ? null : var.rbac_aad_client_app_id
    server_app_id          = var.is_managed_ad ? null : var.rbac_aad_server_app_id
    server_app_secret      = var.is_managed_ad ? null : var.rbac_aad_server_app_secret
  }
  default_node_pool {
    name                  = var.node_pool_name
    node_count            = var.node_pool_count
    enable_node_public_ip = var.node_public_ip_enable
    vm_size               = var.node_pool_vm_size
    max_pods              = var.node_pool_max_pods
    os_disk_size_gb       = var.node_pool_os_disk_size_gb
    vnet_subnet_id        = var.cluster_subnet_id
    enable_auto_scaling   = var.auto_scaling_enable
    min_count             = var.auto_scaling_enable == true ? var.auto_scaling_min_count : null
    max_count             = var.auto_scaling_enable == true ? var.auto_scaling_max_count : null
  }

  linux_profile {
    admin_username = var.linux_admin_username
    ssh_key {
      key_data = var.linux_ssh_key
    }
  }

  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    dns_service_ip    = local.dns_service_ip
    service_cidr      = var.vnet_service_cidr
    load_balancer_sku = var.network_load_balancer_sku
    pod_cidr          = var.network_plugin == "kubenet" ? var.pod_cidrs : null
  }
  tags = var.tags
}

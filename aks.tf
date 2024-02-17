# Define the resource group
resource "azurerm_resource_group" "aks_qatar_ipay_dev_rg" {
  name     = "aks_qatar_ipay_dev_rg"
  location = "East US"
}

# Define the virtual network
resource "azurerm_virtual_network" "aks_qatar_ipay_dev_vnet" {
  name                = "aks_qatar_ipay_dev_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_qatar_ipay_dev_rg.location
  resource_group_name = azurerm_resource_group.aks_qatar_ipay_dev_rg.name
}

# Define the first subnet within the virtual network
resource "azurerm_subnet" "aks_qatar_ipay_dev_subnet1" {
  name                 = "aks_qatar_ipay_dev_subnet1"
  resource_group_name  = azurerm_resource_group.aks_qatar_ipay_dev_rg.name
  virtual_network_name = azurerm_virtual_network.aks_qatar_ipay_dev_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define the second subnet within the virtual network
resource "azurerm_subnet" "aks_qatar_ipay_dev_subnet2" {
  name                 = "aks_qatar_ipay_dev_subnet2"
  resource_group_name  = azurerm_resource_group.aks_qatar_ipay_dev_rg.name
  virtual_network_name = azurerm_virtual_network.aks_qatar_ipay_dev_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Define the AKS cluster
resource "azurerm_kubernetes_cluster" "aks_qatar_ipay_dev" {
  name                = "aks_qatar_ipay_dev"
  location            = azurerm_resource_group.aks_qatar_ipay_dev_rg.location
  resource_group_name = azurerm_resource_group.aks_qatar_ipay_dev_rg.name
  dns_prefix          = "aks-qatar-ipay-dev"
  kubernetes_version  = "1.27.0"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 50

    vnet_subnet_id = azurerm_subnet.aks_qatar_ipay_dev_subnet1.id
  }

  node_pool "app_pool" {
    name            = "app-pool"
    node_count      = 2
    min_count       = 2
    max_count       = 10
    vm_size         = "Standard_DS2_v2"
    os_disk_size_gb = 50

    vnet_subnet_ids = [
      azurerm_subnet.aks_qatar_ipay_dev_subnet1.id,
      azurerm_subnet.aks_qatar_ipay_dev_subnet2.id
    ]

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
    network_plugin = "azure"
    dns_service_ip = "10.2.0.10"
    service_cidr   = "10.2.0.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  tags = {
    Environment        = "Production"
    "support team"     = "Qatar Cloud Team"
    "maintenance window" = "10PM to 00:30 AM on Monday"
  }
}

# Define the Application Gateway
resource "azurerm_application_gateway" "aks_qatar_ipay_dev_app_gateway" {
  name                = "aks-qatar-ipay-dev-app-gateway"
  resource_group_name = azurerm_resource_group.aks_qatar_ipay_dev_rg.name
  location            = azurerm_resource_group.aks_qatar_ipay_dev_rg.location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.aks_qatar_ipay_dev_subnet1.id
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appGatewayFrontendIp"
    public_ip_address_id = azurerm_public_ip.aks_qatar_ipay_dev_public_ip.id
  }

  http_settings {
    name                      = "appGatewayHttpSettings"
    cookie_based_affinity     = "Disabled"
    port                      = 80
    protocol                  = "Http"
    request_timeout           = 20
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_id           = azurerm_application_gateway_http_listener.aks_qatar_ipay_dev_http_listener.id
    backend_address_pool_id    = azurerm_application_gateway_backend_address_pool.aks_qatar_ipay_dev_backend_pool.id
    backend_http_settings_id   = azurerm_application_gateway_http_settings.aks_qatar_ipay_dev_http_settings.id
  }

  tags = {
    Environment = "Production"
  }
}

# Assign AKS Cluster User Role to a user, group, or service principal
resource "azurerm_role_assignment" "aks_cluster_user_role_assignment" {
  scope                = azurerm_kubernetes_cluster.aks_qatar_ipay_dev.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = "principal_id_here"
}

# Deploy the Kubernetes dashboard using Helm
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks_qatar_ipay_dev.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_qatar_ipay_dev.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_qatar_ipay_dev.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_qatar_ipay_dev.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "kubernetes_dashboard" {
  name       = "dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  version    = "5.2.0"
  namespace  = "kube-system"
}

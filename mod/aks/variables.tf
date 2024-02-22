variable "name" {
  type        = string
  description = "(Required) The name of the Azure Kubernetes Service. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The location where the resource group should be created. For a list of all Azure locations, please consult this link or run az account list-locations --output table."
}

variable "resource_group" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
}

variable "kubernetes_version" {
  type        = string
  description = "(Required) Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). NOTE: Upgrading your cluster may take up to 10 minutes per node."
}
variable "tags" {
  default = null
}

variable "private_enabled" {
  default     = false
  description = "Default kubernetes api type as private or public"
  type        = bool
}
variable "rbac_enabled" {
  default     = false
  description = "If RBAC enabled"
}
variable "sku" {
  default     = "Free"
  description = "Tier sku to provide here as Free Standard or Premium"
}
variable "is_managed_ad" {
  default     = false
  description = "If you want to manage RBAC using AAD/ Entra ID"
}
variable "node_resource_group" {
  type        = string
  description = "(Optional) The name of the Resource Group where the Kubernetes Nodes should exist. Changing this forces a new resource to be created. If empty, this module will generate a friendly name"
  default     = ""
}

variable "node_public_ip_enable" {
  type        = bool
  description = "(Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false."
  default     = false
}

variable "dns_prefix" {
  type        = string
  description = "(Optional) DNS prefix to append to the cluster. Default: mevijay"
  default     = "mevijay"
}

variable "node_pool_name" {
  type        = string
  description = "(Optional) Node Pool name. Default: default"
  default     = "default"
}

variable "node_pool_count" {
  type        = number
  description = "(Optional) Number of pool virtual machines to create. Default: 3"
  default     = 2
}

variable "node_pool_os_disk_size_gb" {
  type        = number
  description = "(Optional) The size of the OS Disk which should be used for each agent in the Node Pool. Changing this forces a new resource to be created. Default: 60"
  default     = 60
}

variable "node_pool_max_pods" {
  type        = number
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  default     = 60
}

variable "node_pool_type" {
  type        = string
  description = "(Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets."
  default     = "VirtualMachineScaleSets"
}

variable "auto_scaling_enable" {
  type        = bool
  description = "(Optional) Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to false."
  default     = false
}

variable "auto_scaling_min_count" {
  type        = number
  description = "(Optional) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100"
  default     = 0
}

variable "auto_scaling_max_count" {
  type        = number
  description = "(Optional) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100."
  default     = 0
}

variable "node_pool_vm_size" {
  type        = string
  description = "(Optional) VM Size to create in the default node pool. Default: Standard_DS3_v2"
  default     = "Standard_DS3_v2"
}

variable "network_plugin" {
  type        = string
  description = "(Optional) Network plugin to use for networking. Currently supported values are azure and kubenet. Changing this forces a new resource to be created. Defaults to azure"
  default     = "azure"
}

variable "network_policy" {
  type        = string
  description = "(Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. This field can only be set when network_plugin is set to azure. Currently supported values are calico and azure. Changing this forces a new resource to be created. Defaults to calico"
  default     = "calico"
}

variable "network_load_balancer_sku" {
  type        = string
  description = "(Optional) Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are basic and standard. Defaults to basic."
  default     = "basic"
}
variable "cluster_subnet_id" {
  default     = null
  description = "Subnet ids for the cluster nodepool"
}
variable "rbac_aad_admin" {
  type        = list(string)
  description = "(Optional) Default Azure Active Directory group assigned as cluster administrator"
  default     = null
}
variable "pod_cidrs" {
  default     = null
  description = "Pod CIDR to be configured "
}

variable "rbac_aad_client_app_id" {
  type        = string
  description = "(Optional) The Client ID of an Azure Active Directory Application. Changing this forces a new resource to be created."
  default     = null
}

variable "rbac_aad_server_app_id" {
  type        = string
  description = "(Optional) The Server ID of an Azure Active Directory Application. Changing this forces a new resource to be created."
  default     = null
}

variable "rbac_aad_server_app_secret" {
  type        = string
  description = "(Optional) The Server Secret of an Azure Active Directory Application. Changing this forces a new resource to be created."
  default     = null
}

variable "rbac_aad_tenant_id" {
  type        = string
  description = "(Optional) The Tenant ID used for Azure Active Directory Application. If this isn't specified the Tenant ID of the current Subscription is used. Changing this forces a new resource to be created."
  default     = null
}

variable "linux_admin_username" {
  type        = string
  description = "(Optional) The Admin Username for the Cluster. Changing this forces a new resource to be created. Defaults to vijay"
  default     = "vijay"
}

variable "linux_ssh_key" {
  type        = string
  description = "(Required) The Public SSH Key used to access the cluster. Changing this forces a new resource to be created."
}

variable "vnet_service_cidr" {
  type        = string
  description = "(Optional) The service cidr"
  default     = "172.16.32.0/19"
}

variable "oms_log_analytics_workspace_id" {
  type        = string
  description = "(Optional) The Log Analytics Workspace id where the OMS should store logs."
  default     = null
}

variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "(Optional) The IP ranges to whitelist for incoming traffic to the masters."
  default     = []
}

variable "http_application_routing_enabled" {
  type        = bool
  description = "(Optional) Enables http application routing"
  default     = false
}
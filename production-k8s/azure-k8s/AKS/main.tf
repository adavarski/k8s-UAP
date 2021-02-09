 provider "azurerm" {
   # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
   version = "~>2.0"
    
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    features{

    }
 }

resource "azurerm_resource_group" "k8s" {
  name     = var.resourcename
  location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.clustername
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dnspreffix
  kubernetes_version  = var.kubernetes_version

default_node_pool {
    name       = "default"
    node_count = var.agentnode
    vm_size    = var.size
  }

service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }




tags = {
    Environment = "Demo"
  }

role_based_access_control {
    enabled = true  
  }

linux_profile {
    admin_username = "ubuntu"

    ssh_key {
         key_data = file(var.ssh_public_key)
      }
  }

network_profile {
    load_balancer_sku = "Standard"
    network_plugin = "kubenet"
  }

}

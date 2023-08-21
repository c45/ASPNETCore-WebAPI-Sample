resource "azurerm_resource_group" "rg" {
  name     = terraform.workspace
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${terraform.workspace}-bestrong-aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  dns_prefix          = "bestrong-k8s"

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_A2_v2"
    node_count = 3
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "basic"
  }

  role_based_access_control_enabled = true

  tags = {
    env = terraform.workspace
  }
}

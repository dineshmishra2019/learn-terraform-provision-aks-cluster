# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "icx-rg" {
  name     = "ICX-RG-TERRAFORM"
  location = "Central India"

  tags = {
    environment = "Demo"
  }
}
resource "azurerm_container_registry" "icx-acr" {
  name                = "icxcontainerRegistry"
  resource_group_name = azurerm_resource_group.icx-rg.name
  location            = azurerm_resource_group.icx-rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "icx-aks" {
  name                = "icx-aks-cluster"
  location            = azurerm_resource_group.icx-rg.location
  resource_group_name = azurerm_resource_group.icx-rg.name
  dns_prefix          = "icx-aks-k8s-cluster"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Demo"
  }
}



provider "azurerm" {
  features {}
  skip_provider_registration = true
  client_id       = var.appId
  client_secret   = var.password
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "default" {
  name     = var.resourcegrp
  # location = var.location

}

resource "azurerm_kubernetes_cluster" "Gemfire" {
  name                = "Gemfire-aks"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  dns_prefix          = "Gemfire-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2s_v3"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }


  # role_based_access_control {
  #   enabled = true
  # }

  # addon_profile {
  #   kube_dashboard {
  #     enabled = true
  #   }
  # }

  tags = {
    environment = "Demo"
  }
}


provider "helm" {
  kubernetes {
    host = azurerm_kubernetes_cluster.Gemfire.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.cluster_ca_certificate) 
  }
  # registry {
  #   url = "oci://registry.tanzu.vmware.com/"
  #   username = var.reguser
  #   password = var.regpassword
  # }  
}

provider "kubernetes" {
    host = azurerm_kubernetes_cluster.Gemfire.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.cluster_ca_certificate) 
}

provider "kubectl" {
  host = azurerm_kubernetes_cluster.Gemfire.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.Gemfire.kube_config.0.cluster_ca_certificate) 
  load_config_file       = false
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress-basic"
  }
}


resource "helm_release" "contour" {
  name       = "contour"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "contour"
  namespace  = kubernetes_namespace.ingress.metadata[0].name
}

# resource "helm_release" "cert-manager" {
#   name       = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   namespace = kubernetes_namespace.cert-manager.metadata[0].name
#   set {
#     name  = "installCRDs"
#     value = "true"
#   }
# }



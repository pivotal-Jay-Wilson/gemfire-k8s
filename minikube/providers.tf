provider "minikube" {
  kubernetes_version = "v1.30.0"
}

provider "helm" {
  kubernetes = {
    host = minikube_cluster.gemfire.host

    client_certificate     = minikube_cluster.gemfire.client_certificate
    client_key             = minikube_cluster.gemfire.client_key
    cluster_ca_certificate = minikube_cluster.gemfire.cluster_ca_certificate
  }
}


provider "kubernetes" {
    host = minikube_cluster.gemfire.host

    client_certificate     = minikube_cluster.gemfire.client_certificate
    client_key             = minikube_cluster.gemfire.client_key
    cluster_ca_certificate = minikube_cluster.gemfire.cluster_ca_certificate
}

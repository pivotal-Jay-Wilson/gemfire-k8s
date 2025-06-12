provider "kind" {}

provider "helm" {
  kubernetes = {
    client_certificate     = kind_cluster.gemfire.client_certificate
    client_key             = kind_cluster.gemfire.client_key
    cluster_ca_certificate = kind_cluster.gemfire.cluster_ca_certificate
  }
  # kubernetes = {
  #   config_path    = "~/.kube/config"
  #   config_context = "kind-gemfire"  
  # }
}


provider "kubernetes" {
    # config_path    = "~/.kube/config"
    # config_context = "kind-gemfire"  

    client_certificate     = kind_cluster.gemfire.client_certificate
    client_key             = kind_cluster.gemfire.client_key
    cluster_ca_certificate = kind_cluster.gemfire.cluster_ca_certificate
}
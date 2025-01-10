provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.config_path
  }
  # registry {
  #   url = "oci://registry.tanzu.vmware.com/"
  #   username = var.reguser
  #   password = var.regpassword
  # }  
}

provider "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = var.config_path
}

provider "kubectl" {
    config_path    = "~/.kube/config"
    config_context = var.config_path
}
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.config_path
  } 
}

provider "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = var.config_path
}

provider "kubectl" {
    config_path    = "~/.kube/config"
    config_context = var.config_path
}
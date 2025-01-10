provider "kind" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "kind-gem-cluster"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-gem-cluster"
  }
}
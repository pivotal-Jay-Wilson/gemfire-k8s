terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }  
    kubectl = {
      source = "alekc/kubectl"
      version = "2.1.3"
    }    
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = ">= 1.14.0"
    # }            
  }
  required_version = "~> 1.0"
}




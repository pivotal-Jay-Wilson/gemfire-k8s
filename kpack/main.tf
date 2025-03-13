
# resource "kubernetes_namespace" "apps" {
#   metadata {
#     name = "registry"
#   }
# }

# resource "kubernetes_secret" "image-pull-secret" {
#   metadata {
#     name = "image-pull-secret"
#     namespace = kubernetes_namespace.apps.metadata[0].name
#   }
  
#   type = "kubernetes.io/dockerconfigjson"

#   data = {
#     ".dockerconfigjson" = jsonencode({
#       auths = {
#         "${var.reg}" = {
#           "username" = var.reguser
#           "password" = var.regpassword
#           "email"    = var.reguser
#           "auth"     = base64encode("${var.reguser}:${var.regpassword}")
#         }
#       }
#     })
#   }
# }

# resource "kubernetes_deployment" "registry" {
#   metadata {
#     name = "registry"
#     namespace = kubernetes_namespace.apps.metadata[0].name
#     labels = {
#       app = "registry"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "registry"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "registry"
#         }
#       }

#       spec {
#         container {
#           image = "registry:2.8.3"
#           name  = "registry"
#           port {
#             container_port = 5000
#           }
#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "registry" {
#   metadata {
#     name = "registry"
#     namespace = "registry"
#   }
#   spec {
#     selector = {
#       app = kubernetes_deployment.registry.metadata[0].labels.app
#     }
#     port {
#       port        = 5000
#       target_port = 5000
#     }

#     type = "ClusterIP"
#   }
# }

data "http" "kpack" {
  url = "https://github.com/buildpacks-community/kpack/releases/download/v0.16.0/release-0.16.0.yaml"

  # Optional request headers
  request_headers = {
    Accept = "application/yaml"
  }
}

resource "kubectl_manifest" "kpack" {
  yaml_body = data.http.kpack.response_body
  depends_on = [ data.http.kpack ]
}

# data "kubectl_path_documents" "release-kpack" {
#     pattern = "./release-0.16.0.yaml"
# }

# resource "kubectl_manifest" "release-kpack" {
#   for_each  = data.kubectl_path_documents.release-kpack.manifests
#   yaml_body = each.value
# }

resource "kubernetes_secret" "kpack-reg-secret" {
  metadata {
    name = "kpack-reg-secret"  
    namespace = "default"
  }
  
  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "http://registry.kube-system.svc.cluster.local" = {
          "username" = var.reguser-store
          "password" = var.regpassword-store
          "email"    = var.regemail-store
          "auth"     = base64encode("${var.reguser-store}:${var.regpassword-store}")
        }
      }
    })
  }
}
resource "kubernetes_service_account" "kpack" {
  metadata {
    name = "kpacksa"
    namespace = "default"
  }
  secret {
    name = kubernetes_secret.kpack-reg-secret.metadata[0].name
  }
  image_pull_secret {
    name = kubernetes_secret.kpack-reg-secret.metadata[0].name
  }
}
# data "kubectl_path_documents" "gmc" {
#     pattern = "./kpack/clusterstore/*.yaml"
# }

# resource "kubectl_manifest" "gmcinstall" {
#   for_each  = data.kubectl_path_documents.gmc.manifests
#   yaml_body = each.value
# }
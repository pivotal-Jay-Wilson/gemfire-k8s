
resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }
}

resource "kubernetes_secret" "image-pull-secret" {
  metadata {
    name = "image-pull-secret"
    namespace = kubernetes_namespace.apps.metadata[0].name
  }
  
  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.reg}" = {
          "username" = var.reguser
          "password" = var.regpassword
          "email"    = var.reguser
          "auth"     = base64encode("${var.reguser}:${var.regpassword}")
        }
      }
    })
  }
}

resource "kubernetes_deployment" "registry" {
  metadata {
    name = "registry"
    namespace = kubernetes_namespace.apps.metadata[0].name
    labels = {
      test = "registry"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "registry"
      }
    }

    template {
      metadata {
        labels = {
          app = "registry"
        }
      }

      spec {
        container {
          image = "registry:2"
          name  = "registry"
          port {
            container_port = 5000
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "registry" {
  metadata {
    name = "registry"
  }
  spec {
    selector = {
      app = kubernetes_deployment.app.metadata[0].labels.app
    }
    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}

data "http" "kpack" {
  url = "https://github.com/buildpacks-community/kpack/releases/download/v0.15.0/release-0.15.0.yaml"

  # Optional request headers
  request_headers = {
    Accept = "application/yaml"
  }
}

resource "kubectl_manifest" "kpack" {
  yaml_body = data.http.kpack.body
  depends_on = [ kubernetes_deployment.registry ]
}


resource "kubernetes_service_account" "kpack" {
  metadata {
    name = "kpack_sa"
    namespace = "default"
  }

}

# k create -f   https://github.com/buildpacks-community/kpack/releases/download/v0.15.0/release-0.15.0.yaml


# resource "kubernetes_secret" "image-pull-secret-local" {
#   metadata {
#     name = "image-pull-secret-local"
#     namespace = kubernetes_namespace.hello.metadata[0].name
#   }
  
#   type = "kubernetes.io/dockerconfigjson"

#   data = {
#     ".dockerconfigjson" = jsonencode({
#       auths = {
#         "${var.reg}" = {
#           "username" = var.reguser-store
#           "password" = var.regpassword-store
#           "email"    = var.reguser-store
#           "auth"     = base64encode("${var.reguser}:${var.regpassword}")
#         }
#       }
#     })
#   }
# }



# data "kubectl_path_documents" "wan" {
#     pattern = "./wan/*.yaml"
# }

# resource "kubectl_manifest" "waninstall" {
#   for_each  = data.kubectl_path_documents.wan.manifests
#   yaml_body = each.value
#   depends_on = [helm_release.gemfire-crd, helm_release.gemfire-operator ]
# }


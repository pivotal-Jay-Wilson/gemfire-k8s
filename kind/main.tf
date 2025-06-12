resource "kind_cluster" "gemfire" {
  name           = "gemfire"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    containerdConfigPatches = 
    - |-
      [plugins."io.containerd.grpc.v1.cri".registry]
        config_path = "/etc/containerd/certs.d"
    
    node {
      role = "control-plane"
    }
    node {
      role = "worker"

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }
  }
}


# resource "kubernetes_namespace" "ingress" {
#   metadata {
#     name = "ingress-basic"
#   }
#   depends_on = [kind_cluster.gemfire]
# }


# resource "helm_release" "contour" {
#   name       = "contour"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "contour"
#   namespace  = kubernetes_namespace.ingress.metadata[0].name
#   # set {
#   #   name  = "hostNetwork"
#   #   value = "true"
#   # }  
#   depends_on = [kind_cluster.gemfire, kubernetes_namespace.ingress ]
# }

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
   depends_on = [kind_cluster.gemfire]
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace =  kubernetes_namespace.cert-manager.metadata[0].name
  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
  depends_on = [kind_cluster.gemfire]
}
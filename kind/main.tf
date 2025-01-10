resource "kind_cluster" "gem-cluster" {
  name           = "gem-cluster"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

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


# resource "docker_image" "cloud-provider-kind" {
#   name = "cloud-provider-kind:1.0"
#   build {
#     context = "${path.cwd}"
#   }
# }

# resource "docker_container" "cloud-provider-kind" {
#   name  = "cloud-provider-kind"
#   image = docker_image.cloud-provider-kind.name
#   networks_advanced {
#     name = "kind"
#   }
#   volumes {
#     "/var/run/docker.sock:/var/run/docker.sock":"/var/run/docker.sock:/var/run/docker.sock"
#   }
#   depends_on = [ docker_image.cloud-provider-kind ]
# }

# kubectl label node kind-control-plane node.kubernetes.io/exclude-from-external-load-balancers-node/kind-control-plane unlabeled
# resource "kubernetes_labels" "node" {
#   api_version = "v1"
#   kind        = "Node"
#   metadata {
#     name = "gem-cluster-control-plane"
#   }
#   labels = {
#     "node.kubernetes.io/exclude-from-external-load-balancers" = ""
#   }
#   depends_on = [kind_cluster.gem-cluster]
# }


resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress-basic"
  }
  depends_on = [kind_cluster.gem-cluster]
}


resource "helm_release" "contour" {
  name       = "contour"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "contour"
  namespace  = kubernetes_namespace.ingress.metadata[0].name
  # set {
  #   name  = "hostNetwork"
  #   value = "true"
  # }  
  depends_on = [kind_cluster.gem-cluster, kubernetes_namespace.ingress ]
}

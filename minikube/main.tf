resource "minikube_cluster" "gemfire" {
  driver       = "docker"
  cpus = 8
  memory = "16 g"
  cluster_name = "gemfire"
  addons = [
    "default-storageclass",
    "storage-provisioner",
    "ingress",
    "ingress-dns",
    "metrics-server"
    # "registry",
    # "registry-aliases"
  ]
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
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

}

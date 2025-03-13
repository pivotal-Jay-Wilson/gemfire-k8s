resource "google_project_service" "default" {
  for_each = toset([
    "anthos.googleapis.com",
    "gkehub.googleapis.com"
  ])

  service            = each.value
  disable_on_destroy = false
}

resource "google_container_cluster" "gemfire" {
  name     = "gemfire-cluster"
  location = var.location
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
}  
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "gemfire"
  location   = var.location
  cluster    = google_container_cluster.gemfire.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb  = 50
  }
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

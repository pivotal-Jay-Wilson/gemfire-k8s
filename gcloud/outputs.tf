
output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.gemfire.name
  description = "GKE Cluster Name"
}


output "host" {
  value = google_container_cluster.gemfire.endpoint
}

output "client_certificate" {
  value = base64decode(google_container_cluster.gemfire.master_auth.0.cluster_ca_certificate)
}

output "client_key" {
  sensitive = true
  value = base64decode(google_container_cluster.gemfire.master_auth.0.client_key)
}

output "cluster_ca_certificate" {
  sensitive = true
  value = base64decode(google_container_cluster.gemfire.master_auth.0.cluster_ca_certificate)
}

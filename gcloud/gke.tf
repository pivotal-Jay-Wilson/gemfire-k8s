
resource "google_container_cluster" "primary" {
  name     = "gemfire-cluster"
  location = var.location
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "gemfire"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb  = 50
  }
}


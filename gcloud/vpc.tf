
# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc1"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.location
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

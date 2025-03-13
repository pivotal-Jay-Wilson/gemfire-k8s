provider "google" {
  project = var.project_id
  region  = var.location
}

data "google_client_config" "oauth" {
}

provider "helm" {
  kubernetes = {
  host  = "https://${google_container_cluster.gemfire.endpoint}"
  token = data.google_client_config.oauth.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.gemfire.master_auth[0].cluster_ca_certificate,
  )  }
}


provider "kubernetes" {
  host  = "https://${google_container_cluster.gemfire.endpoint}"
  token = data.google_client_config.oauth.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.gemfire.master_auth[0].cluster_ca_certificate,
  )
}


provider "google" {
  version = "~> 2.15.0"
  project = var.project
  region  = var.region
}



resource "google_container_cluster" "cluster-1" {
  name                     = "my-gke-cluster"
  location                 = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    kubernetes_dashboard {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "reddit_app-pool" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.cluster-1.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    disk_size_gb = 20

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_compute_firewall" "firewall-gke-reddit" {
  name        = "allow-reddit-gke"
  description = "Alow port for gke-reddit"
  network     = "default"
  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
  source_ranges = ["0.0.0.0/0"]
}

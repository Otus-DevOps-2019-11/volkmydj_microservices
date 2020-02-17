provider "google" {
  version = "2.15"
  project = var.project
  region  = var.region
}


resource "google_compute_instance" "gitlab" {
  count        = var.instances_count
  name         = "${var.app_name}${count.index}"
  machine_type = "n1-standard-1"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.gitlab-docker_ip.address
    }
  }
  tags = ["gitlab-docker"]
}

resource "google_compute_address" "gitlab-docker_ip" {
  name = "gitlab-docker-ip"
}

resource "google_compute_firewall" "firewall_gitlab" {
  name        = "allow-gitlab-default"
  description = "Alow port for docker-gitlab"
  network     = "default"
  allow {
    protocol = "tcp"
    ports    = ["80","443","9292","2222"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gitlab-docker"]
}

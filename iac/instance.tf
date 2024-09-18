resource "google_compute_instance" "server_1" {
  name         = "${var.prefix}-server-1"
  machine_type = "e2-medium"
  zone         = var.zone_1

  boot_disk {
    initialize_params {
      image = "projects/${var.project_id}/global/images/mweb-server-1"
      type  = "pd-balanced"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.default.name
    subnetwork = google_compute_subnetwork.subnet_1.id
    network_ip = "10.0.0.10"
    access_config {
    }
  }

  metadata = {
    user-data = file("./cloud-config/server-1.yaml")
  }

  tags = setunion(
    google_compute_firewall.allow-internal.target_tags,
    google_compute_firewall.allow-ssh.target_tags,
    google_compute_firewall.allow-health-check.target_tags,
  )
}

resource "google_compute_instance" "server_2" {
  name         = "${var.prefix}-server-2"
  machine_type = "e2-medium"
  zone         = var.zone_2

  boot_disk {
    initialize_params {
      image = "projects/${var.project_id}/global/images/mweb-server-2"
      type  = "pd-balanced"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.default.name
    subnetwork = google_compute_subnetwork.subnet_2.id
    network_ip = "10.1.0.10"
    access_config {
    }
  }

  metadata = {
    user-data = file("./cloud-config/server-2.yaml")
  }

  tags = setunion(
    google_compute_firewall.allow-internal.target_tags,
    google_compute_firewall.allow-ssh.target_tags,
    google_compute_firewall.allow-health-check.target_tags,
  )
}

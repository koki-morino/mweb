resource "google_compute_network" "default" {
  name                    = "${var.prefix}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_1" {
  name          = "${var.prefix}-subnet-tokyo"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region_1
  network       = google_compute_network.default.id
}

resource "google_compute_subnetwork" "subnet_2" {
  name          = "${var.prefix}-subnet-osaka"
  ip_cidr_range = "10.1.0.0/16"
  region        = var.region_2
  network       = google_compute_network.default.id
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${var.prefix}-firewall-allow-internal"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp" # Pinging
  }

  allow {
    protocol = "tcp"
    ports = [
      "7777",      # OCFS2
      "7788-7789", # DRBD
    ]
  }

  source_ranges = ["10.0.0.0/16", "10.1.0.0/16"]
  target_tags   = ["internal"]
}

resource "google_compute_firewall" "allow-ssh-all" {
  name    = "${var.prefix}-firewall-allow-ssh-all"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-all"]
}

resource "google_compute_firewall" "allow-http-all" {
  name    = "${var.prefix}-firewall-allow-http-all"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports = [
      "80", # Nginx
    ]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-all"]
}

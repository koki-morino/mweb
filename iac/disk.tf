resource "google_compute_disk" "disk_1" {
  name = "${var.prefix}-drbd-disk-1"
  zone = var.zone_1
  type = "pd-balanced"
  size = 50
}

resource "google_compute_disk" "disk_2" {
  name = "${var.prefix}-drbd-disk-2"
  zone = var.zone_2
  type = "pd-balanced"
  size = 50
}

resource "google_compute_attached_disk" "attached_disk_1" {
  disk        = google_compute_disk.disk_1.id
  instance    = google_compute_instance.server_1.id
  device_name = "dup"
}

resource "google_compute_attached_disk" "attached_disk_2" {
  disk        = google_compute_disk.disk_2.id
  instance    = google_compute_instance.server_2.id
  device_name = "dup"
}

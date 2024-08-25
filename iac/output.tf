output "server_1_ip" {
  value = google_compute_instance.server_1.network_interface[0].access_config[0].nat_ip
}

output "server_2_ip" {
  value = google_compute_instance.server_2.network_interface[0].access_config[0].nat_ip
}

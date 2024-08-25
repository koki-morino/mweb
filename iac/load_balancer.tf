module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 9.0"

  project = var.project_id
  name    = "${var.prefix}-https-lb"

  http_forward   = false
  https_redirect = true

  ssl         = true
  private_key = file("private/privkey.pem")
  certificate = file("private/cert.pem")

  backends = {
    http = {
      protocol    = "HTTP"
      port        = var.service_port
      port_name   = var.service_port_name
      timeout_sec = 60

      enable_cdn = false

      health_check = {
        request_path = "/"
        port         = var.service_port
      }

      log_config = {
        enable = false
      }

      groups = [
        {
          group = google_compute_instance_group.instance_group_1.id
        },
        {
          group = google_compute_instance_group.instance_group_2.id
        },
      ]

      iap_config = {
        enable = false
      }
    }
  }
}

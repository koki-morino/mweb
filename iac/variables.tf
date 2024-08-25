variable "prefix" {
  default = "mweb"
}

variable "domain" {}

variable "project_id" {}

variable "region_1" {
  # Tokyo
  default = "asia-northeast1"
}

variable "region_2" {
  # Osaka
  default = "asia-northeast2"
}

variable "zone_1" {
  default = "asia-northeast1-a"
}

variable "zone_2" {
  default = "asia-northeast2-a"
}

variable "service_port" {
  default = "80"
}

variable "service_port_name" {
  default = "http"
}

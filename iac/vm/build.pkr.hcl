packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "prefix" {
  default = "mweb"
}

variable "project_id" {
  type = string
}

variable "zone" {
  type = string
  default = "asia-northeast1-a"
}

source "googlecompute" "server" {
  project_id                  = var.project_id
  zone                        = var.zone
  // File provisioner requires elevated privilege to copy files into non-
  // writable directory like/etc/drbd.d.
  ssh_username                = "root"
  source_image_family         = "ubuntu-2404-lts-amd64"
  image_name                  = "${var.prefix}-server"
  disk_size                   = 20
}

build {
  sources = [
    "sources.googlecompute.server",
  ]

  // Install packages.
  provisioner "shell" {
    environment_vars = ["USERNAME=koki"]
    scripts = [
      "./add-hostnames.sh",
      "./install-packages.sh",
    ]
  }

  provisioner "file" {
    sources = [
      "../drbd.d",
      "../ocfs2",
    ]
    destination = "/etc/"
  }

  provisioner "shell" {
    inline = [
      "cp /etc/drbd.d/notify-split-brain.sh /sbin/",
      "sudo chmod 755 /sbin/notify-split-brain.sh",
      "cp /etc/drbd.d/fence-self.sh /sbin/",
      "sudo chmod 755 /sbin/fence-self.sh",
      "mkdir -p /home/koki"
    ]
  }

  provisioner "file" {
    sources = [
      "../containers/production.yml",
    ]
    destination = "/home/koki/compose.yml"
  }
}

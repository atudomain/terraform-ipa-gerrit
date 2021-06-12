terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

locals {
  hostname    = "${var.host}.${var.domain}"
  volume_name = "${var.host}_data"
  realm       = upper("${var.host}.${var.domain}")
}

resource "docker_image" "ipa" {
  name         = "freeipa/freeipa-server:fedora-rawhide"
  keep_locally = true
}

resource "docker_volume" "ipa_data" {
  name = local.volume_name
}

resource "docker_container" "ipa" {
  image    = docker_image.ipa.latest
  name     = var.host
  hostname = local.hostname
  sysctls = {
    "net.ipv6.conf.all.disable_ipv6" = 0
  }
  restart = "unless-stopped"
  command = [
    "--unattended",
    "--ds-password=${var.ds_password}",
    "--admin-password=${var.admin_password}",
    "--realem=${local.realm}",
    "--no-ntp"
  ]
  volumes {
    container_path = "/data"
    volume_name    = local.volume_name
  }
  volumes {
    container_path = "/sys/fs/cgroup"
    host_path      = "/sys/fs/cgroup"
    read_only      = true
  }
  networks_advanced {
    name    = var.network
    aliases = [local.hostname]
  }
}

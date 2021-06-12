terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

locals {
  hostname               = "${var.host}.${var.domain}"
  volume_name_etc        = "${var.host}_etc"
  volume_name_git        = "${var.host}_git"
  volume_name_db         = "${var.host}_db"
  volume_name_index      = "${var.host}_index"
  volume_name_cache      = "${var.host}_cache"
  gerrit_canonicalWebUrl = "http://${var.host}.${var.domain}"
  ldap_server            = "ldap://${var.ldap_host}.${var.domain}"
  ldap_username          = replace("cn=${var.ldap_cn}.${var.domain}", ".", ",dc=")
  ldap_accountBase       = replace("dc=${var.domain}", ".", ",dc=")
}

resource "docker_image" "gerrit" {
  name = "custom-gerrit"
  build {
    path = "./image"
    tag  = ["latest"]
    label = {
      author : "atudomain"
    }
  }
  keep_locally = true
}

resource "docker_volume" "gerrit_etc" {
  name = local.volume_name_etc
}

resource "docker_volume" "gerrit_git" {
  name = local.volume_name_git
}

resource "docker_volume" "gerrit_db" {
  name = local.volume_name_db
}

resource "docker_volume" "gerrit_index" {
  name = local.volume_name_index
}

resource "docker_volume" "gerrit_cache" {
  name = local.volume_name_cache
}

resource "docker_container" "gerrit" {
  image    = docker_image.gerrit.latest
  name     = var.host
  hostname = local.hostname
  restart  = "unless-stopped"
  volumes {
    container_path = "/var/gerrit/etc"
    volume_name    = local.volume_name_etc
  }
  volumes {
    container_path = "/var/gerrit/git"
    volume_name    = local.volume_name_git
  }
  volumes {
    container_path = "/var/gerrit/db"
    volume_name    = local.volume_name_db
  }
  volumes {
    container_path = "/var/gerrit/index"
    volume_name    = local.volume_name_index
  }
  volumes {
    container_path = "/var/gerrit/cache"
    volume_name    = local.volume_name_cache
  }
  networks_advanced {
    name    = var.network
    aliases = [local.hostname]
  }
  env = [
    "GERRIT_CANONICAL_WEB_URL=${local.gerrit_canonicalWebUrl}",
    "LDAP_SERVER=${local.ldap_server}",
    "LDAP_USERNAME=${local.ldap_username}",
    "LDAP_ACCOUNTBASE=${local.ldap_accountBase}"
  ]
}

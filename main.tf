terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.12.2"
    }
  }
  required_version = ">= 0.14.9"
}

provider "docker" {}

resource "docker_network" "ipa_gerrit" {
  name = "ipa-gerrit"
}

module "ipa" {
  source = "./ipa"

  network        = "ipa-gerrit"
  host           = "ipa"
  domain         = "ci.local"
  ds_password    = var.ds_password
  admin_password = var.admin_password
}

module "gerrit" {
  source = "./gerrit"

  dockerfile_path = "./gerrit/image"

  network       = "ipa-gerrit"
  host          = "gerrit"
  domain        = "ci.local"
  ldap_host     = "ipa"
  ldap_uid       = "admin"
  ldap_password = var.admin_password
}

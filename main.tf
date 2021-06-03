terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_network" "ipa-gerrit" {
  name = "ipa-gerrit"
}

module "ipa" {
  source  = "./ipa"
  network = "ipa-gerrit"
}

# module "gerrit" {
#   source = "./gerrit"
# }

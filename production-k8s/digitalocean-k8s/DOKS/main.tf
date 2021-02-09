provider "digitalocean" {
  version = "~> 1.0"
  token   = var.do_token
}

resource "digitalocean_vpc" "vpc" {
  name     = var.name
  region   = var.region
  ip_range = var.vpc_cidr
}

resource "digitalocean_kubernetes_cluster" "primary" {
  name     = var.name
  region   = digitalocean_vpc.vpc.region
  version  = var.cluster_version
  vpc_uuid = digitalocean_vpc.vpc.id
  node_pool {
    name       = "primary"
    size       = var.node_size
    auto_scale = true
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
  }
}

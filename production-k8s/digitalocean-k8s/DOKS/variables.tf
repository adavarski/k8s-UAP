variable "do_token" {}
variable "name" {}
variable "region" {}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "cluster_version" {
  default = "1.18.3-do.0"
}

variable "node_size" {
  default = "s-1vcpu-2gb"
}

variable "min_nodes" {
  default = 1
}

variable "max_nodes" {
  default = 2
}

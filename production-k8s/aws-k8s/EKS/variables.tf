variable "name" {
  type        = string
  description = "Name of the cluster."
}

variable "region" {
  type        = string
  description = "AWS region the cluster will reside in."
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR."
}

variable "subnet_addtl_bits" {
  type        = number
  default     = 4
  description = <<EOF
Additional bits added to VPC CIDR, to determine subnet size.
e.g. a VPC CIDR of 10.0.0.0/16 and 4 additional bits will yield subnets
10.0.0.0/20, 10.0.16.0/20, 10.0.0.32.0/20, and so on.
See https://www.linux.com/topic/networking/how-calculate-network-addresses-ipcalc/
and https://www.terraform.io/docs/configuration/functions/cidrsubnet.html
EOF
}

variable "num_zones" {
  type        = number
  default     = 2
  description = <<EOF
Number of availability zones the cluster will reside in.
This needs to be at least 2, due to EKS restrictions.
See https://aws.amazon.com/about-aws/global-infrastructure/regions_az/ for more details.
EOF
}

variable "endpoint_private_access" {
  type        = bool
  default     = false
  description = "Whether the private API endpoint is enabled"
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "Whether the public API endpoint is enabled"
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDRs that can access the public API server"
}

variable "node_pools" {
  type        = list(map(string))
  description = <<EOF
List of node pools to use for the cluster.
See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
EOF
}

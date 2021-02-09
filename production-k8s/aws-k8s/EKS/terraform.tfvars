name      = "mycluster"
region    = "ap-southeast-2"
num_zones = 2
node_pools = [
  {
    instance_type = "t3.small"
    disk_size     = 20
    desired_size  = 1
    min_size      = 1
    max_size      = 2
  }
]

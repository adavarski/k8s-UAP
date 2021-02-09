provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "windy-art-303706"
  region      = "europe-west2"
  zone        = "europe-west2-a"
}

resource "google_container_cluster" "gke-cluster" {
  name                     = "gke-demo"
  remove_default_node_pool = true

  node_pool {
    name = "default-pool"
  }
}

resource "google_container_node_pool" "primary_pool" {
  name       = "primary-pool"
  cluster    = "${google_container_cluster.gke-cluster.name}"
  node_count = "1"

  node_config {
    machine_type = "n1-standard-1"
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

}

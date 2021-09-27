# Terraform configuration goes here
provider "google" {
  project = var.project
 #credentials = file("**.json")
  region  = var.region
  zone    = var.zone
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
   byte_length = 8
}

// Enable googleapis
resource "google_project_service" "compute_api" {
  project = var.project
  service = "compute.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "oslogin_api" {
  project = var.project
  service = "oslogin.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "iam_api" {
  project = var.project
  service = "iam.googleapis.com"
  disable_on_destroy = false
}

####################################################################################
# Networking
####################################################################################
# Could be implemented as own network and sub network

resource "google_compute_network" "dataproc_network" {
  name = "dataproc-network"
}

# Ask for a static external ip for master node
resource "google_compute_address" "vm_static_ip_query" {
  name = "query-static-ip-master"
  address_type = "EXTERNAL"
}

####################################################################################
# Dataproc Cluster
####################################################################################
# Build Nodes
resource "google_dataproc_cluster" "mydataproc" {
  name     = "dataproc-cluster-${random_id.instance_id.hex}"
  region   = var.region
  labels = {
    foo = "bar"
  }

  cluster_config {
    staging_bucket = var.staging_bucket

    master_config {
      num_instances = var.count_server["master"]
      machine_type  = var.machine_types["master"]
      disk_config {
        boot_disk_type    = var.disk_type["master"]
        boot_disk_size_gb = var.disk_size["master"]
      }
    }

    worker_config {
      num_instances    = var.count_server["worker"]
      machine_type     = var.machine_types["worker"]
      disk_config {
        boot_disk_type    = var.disk_type["worker"]
        boot_disk_size_gb = var.disk_size["worker"]
      }
    }

    preemptible_worker_config {
      num_instances = var.count_server["preemptible"]
    }

    # Override or set some custom properties
    software_config {
      image_version = var.image_version
      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "true"
      }
    }

    gce_cluster_config {
      tags = ["foo", "bar"]
      service_account_scopes = [
        "https://www.googleapis.com/auth/monitoring",
        "useraccounts-ro",
        "storage-rw",
        "logging-write",
      ]
      network    = google_compute_network.dataproc_network.name
      #service_account = var.service_account #optional if you want to choose a service account
    }

    # You can define multiple initialization_action blocks
    initialization_action {
      script      = "gs://dataproc-initialization-actions/stackdriver/stackdriver.sh"
      timeout_sec = 500
    }
  }
}

####################################################################################
# Firewalls rules
####################################################################################

resource "google_compute_firewall" "allow_hive_jdbc" {
 name    = "dataproc-hive-allow-jdbc"
 network = google_compute_network.dataproc_network.name

 allow {
   protocol = "tcp"
   ports    = ["10000"]
 }

 source_ranges = ["0.0.0.0/0"]
 target_tags = ["hive-jdbc"]
}

resource "google_compute_firewall" "allow_ssh" {
 name    = "dataproc-ssh-firewall"
 network = google_compute_network.dataproc_network.name

 allow {
   protocol = "tcp"
   ports    = ["22"]
 }

 source_ranges = ["0.0.0.0/0"]
}

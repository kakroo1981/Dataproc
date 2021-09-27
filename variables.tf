# Terraform Variables That Will Be Referenced In "main.tf" Google Cloud Resource Terraform Configuration
variable "project" {
}

variable "location" {
  type = string
  default = "US"
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

# Either implicitly by using a default value of empty brackets:
variable "cidrs" { default = [] }

variable "environment" {
  type = string
  default = "master"
}

variable "machine_types" {
  type = map(string)
  default = {
    "worker" = "e2-micro"
    "master" = "e2-micro"
    "preemptible" = "e2-micro"
  }
}

variable "disk_type" {
  type = map(string)
  default = {
    "worker" = "pd-standard"
    "master" = "pd-standard"
    "preemptible" = "pd-standard"
  }
}

variable "disk_image" {
   type = string
   default = "debian-cloud/debian-10"
 }

variable "disk_size" {
  type = map(string)
  default = {
    "worker" = 25
    "master" = 25
  }
}

variable "count_server" {
  type = map(string)
  default = {
    "worker" = 1
    "master" = 1
    "preemptible" = 0
  }
}

variable "service_account" {
  type = string
}

variable "image_version" {
  type = string
  default = "2.0-debian10"
}


variable "staging_bucket" {
  type = string
}

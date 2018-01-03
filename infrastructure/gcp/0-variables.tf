variable "project_id" {}

variable "service_account_key_file" {}
variable "service_account_email" {}

variable "region" {
  type    = "string"
  default = "europe-west1"
}

variable "zone" {
  type    = "string"
  default = "europe-west1-d"
}

variable "prefix" {
    type = "string"
    default = ""
}

variable "cidr" {
    type = "string"
    default = "10.10.10.0/24"
}

/* variable "dns_suffix" { */
/*   type    = "string" */
/*   default = "play.karampok.me" */
/* } */

variable "allowed_ips" {
  type = "string"
}

provider "google" {
  project     = "${var.project_id}"
  region      = "${var.region}"
  credentials = "${file(var.service_account_key_file)}"
}

resource "google_compute_network" "bosh-net" {
  name                    = "${var.prefix}-net"
  project                 = "${var.project_id}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "bosh-subnet-1" {
  name          = "${var.prefix}-subnet"
  ip_cidr_range = "${var.cidr}"
  network       = "${google_compute_network.bosh-net.self_link}"
  project       = "${var.project_id}"
}

resource "google_compute_address" "static_ip" {
  name    = "${var.prefix}-net"
}



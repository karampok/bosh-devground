variable "ssh_pub_key" {}
variable "ssh_user" {}

// Allow SSH to BOSH bastion
resource "google_compute_firewall" "bosh-bastion" {
  name    = "${var.prefix}-bastion"
  network = "${google_compute_network.bosh-net.name}"
  project     = "${var.project_id}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["bosh-bastion"]
  source_ranges = ["${var.allowed_ips}"]
}


// BOSH bastion host
resource "google_compute_instance" "bosh-bastion" {
  name         = "${var.prefix}-bastion"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"

  tags = ["bosh-bastion", "internal"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  network_interface {
    subnetwork         = "${google_compute_subnetwork.bosh-subnet-1.name}"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = "echo hi > /test.txt"

  metadata {
    sshKeys = "${var.ssh_user}:${var.ssh_pub_key}"
  }

  service_account {
    email = "${var.service_account_email}"
    scopes = ["cloud-platform"]
  }
}


output "bastion_ip" {
  value = "${google_compute_instance.bosh-bastion.network_interface.0.access_config.0.assigned_nat_ip}"
}

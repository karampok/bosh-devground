/* resource "google_compute_route" "nat-primary" { */
/*   name                   = "${var.prefix}nat-primary" */
/*   dest_range             = "0.0.0.0/0" */
/*   network                = "${google_compute_network.bosh.name}" */
/*   next_hop_instance      = "${google_compute_instance.nat-instance-private-with-nat-primary.name}" */
/*   next_hop_instance_zone = "${var.zone}" */
/*   priority               = 800 */
/*   tags                   = ["no-ip"] */
/*   project                = "${var.network_project_id}" */
/* } */


// Allow ssh, bosh-agent mbus, director API, HTTP(S), CF SSH proxy access to director
resource "google_compute_firewall" "direct-access" {
  name    = "${var.prefix}-director-access"
  network = "${google_compute_network.bosh-net.name}"
  project     = "${var.project_id}"

  allow {
    protocol = "tcp"
    ports = ["22", "6868", "25555", "80", "443", "2222", "8443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["${var.allowed_ips}","${google_compute_address.static_ip.address}/32"]
  target_tags = ["director"]
}


// Allow all traffic within subnet
/* resource "google_compute_firewall" "intra-subnet-open" { */
/*   name    = "${var.prefix}intra-subnet-open" */
/*   network = "${google_compute_network.bosh-net.name}" */
/*   project = "${var.project_id}" */

/*   allow { */
/*     protocol = "icmp" */
/*   } */

/*   allow { */
/*     protocol = "tcp" */
/*     ports    = ["1-65535"] */
/*   } */

/*   allow { */
/*     protocol = "udp" */
/*     ports    = ["1-65535"] */
/*   } */

/*   source_tags = ["internal"] */
/* } */



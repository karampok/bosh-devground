output "project_id" {
  value = "${var.project_id}"
}

output "region" {
  value = "${var.region}"
}

output "zone" {
  value = "${var.zone}"
}

output "service_account_email" {
  value = "${var.service_account_email}"
}

output "network_name" {
  value = "${google_compute_network.bosh-net.name}"
}

output "subnetwork_name" {
  value = "${google_compute_subnetwork.bosh-subnet-1.name}"
}
output "internal_cidr" {
  value = "${google_compute_subnetwork.bosh-subnet-1.ip_cidr_range}"
}

output "internal_gw" {
  value = "${google_compute_subnetwork.bosh-subnet-1.gateway_address}"
}

output "internal_ip" {
  value = "10.10.10.10"
}

output "external_ip" {
  value = "${google_compute_address.static_ip.address}"
}
/* output "domain" { */
/*   value = "${var.env_name}.${var.dns_suffix}" */
/* } */

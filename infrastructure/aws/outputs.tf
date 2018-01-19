output "access_key_id" {
    value = "${var.access_key}"
}

output "secret_access_key" {
    value = "${var.secret_key}"
}

output "key_name" {
    value = "${aws_key_pair.bosh.key_name}"
}


output "zone" {
    value = "${var.zone}"
}

output "region" {
    value = "${var.region}"
}

output "prefix" {
    value = "${var.prefix}"
}

output "internal_ip" {
  value = "10.10.10.10"
}

output "external_ip" {
    value = "${aws_eip.boshdirector.public_ip}"
}

output "internal_gw"{
  value = "10.10.10.1"
}
output "internal_cidr" {
  value = "${var.private_cidr}"
}


output "security_group" {
    value = "${aws_security_group.bosh-sg.name}"
}

output "private_subnet_id" {
    value = "${aws_subnet.private-net.id}"
}

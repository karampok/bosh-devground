resource "aws_security_group" "bastion" {
  name        = "${var.prefix}-bastion-sg"
  description = "Allow access from allowed_network via SSH"
  vpc_id  = "${aws_vpc.default.id}"

  # SSH
  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.allowed_ips)}"]
    self = false
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-bastion-sg"
  }
}
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


variable "ssh_pub_key" {}
resource "aws_key_pair" "bastion_key_pair" {
  key_name = "${var.prefix}-user"
  public_key = "${var.ssh_pub_key}"
}


resource "aws_instance" "bastion" {
    ami           = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"
    subnet_id     = "${aws_subnet.private-net.id}"
    availability_zone = "${var.zone}"
    key_name      = "${var.prefix}-user"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    associate_public_ip_address = true

    tags {
      Name = "${var.prefix}-bastion"
    }
    provisioner "remote-exec" {
      inline = [
        "set -eu",
        "sudo apt-get update",
        "sudo apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3",
        "sudo apt-get install -y git",
        "sudo apt-get install -y unzip",
      ]

      connection {
        type     = "ssh"
        user = "ubuntu"
      }
    }
}

output "bosh-bastion-ip" {
    value = "${aws_instance.bastion.public_ip}"
}



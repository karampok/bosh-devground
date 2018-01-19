resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id  = "${aws_vpc.default.id}"
  tags {
    Name = "${var.prefix}-default-gw"
  }
}

resource "aws_subnet" "private-net" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.private_cidr}"
  availability_zone       = "${var.zone}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.prefix}-private-net"
  }
}

resource "aws_route_table_association" "bosh" {
  subnet_id      = "${aws_subnet.private-net.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "boshdirector" {
    vpc = true
   tags {
    Name = "${var.prefix}-public-ip"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

 tags {
    Name = "${var.prefix}-public-route"
  }

}

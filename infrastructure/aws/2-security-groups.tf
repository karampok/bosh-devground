variable "bosh_ssh_pub_key" {}
resource "aws_key_pair" "bosh" {
  key_name = "${var.prefix}-bosh-key"
  public_key = "${var.bosh_ssh_pub_key}"
}

resource "aws_security_group" "bosh-sg" {
  name        = "${var.prefix}-bosh-director-sg"
  description = "Default BOSH security group"
  vpc_id      = "${aws_vpc.default.id}"
  tags {
    Name = "${var.prefix}-bosh-director-sg"
  }

  ingress {
    from_port   = 6868
    to_port     = 6868
    protocol    = "tcp"
		cidr_blocks = ["${var.allowed_ips}"]
  }

	ingress {
		from_port   = 25555
		to_port     = 25555
		protocol    = "tcp"
		cidr_blocks = ["${var.allowed_ips}"]
	}

	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["${var.allowed_ips}"]
	}


	# outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


/* resource "aws_security_group" "elb_security_group" { */
/*   name        = "${var.tag_name}-${var.env_name}-elb-sg" */
/*   description = "ELB Security Group" */
/*   vpc_id      = "${aws_vpc.default.id}" */

/*   ingress { */
/*     cidr_blocks = ["0.0.0.0/0"] */
/*     protocol    = "tcp" */
/*     from_port   = 80 */
/*     to_port     = 80 */
/*   } */

/*   ingress { */
/*     cidr_blocks = ["0.0.0.0/0"] */
/*     protocol    = "tcp" */
/*     from_port   = 443 */
/*     to_port     = 443 */
/*   } */

/*   ingress { */
/*     cidr_blocks = ["0.0.0.0/0"] */
/*     protocol    = "tcp" */
/*     from_port   = 4443 */
/*     to_port     = 4443 */
/*   } */

/*   ingress { */
/*     self      = true */
/*     protocol  = "-1" */
/*     from_port = 0 */
/*     to_port   = 0 */
/*   } */

/*   egress { */
/*     from_port = 0 */
/*     to_port = 0 */
/*     protocol = "-1" */
/*     cidr_blocks = ["0.0.0.0/0"] */
/*   } */

/*   tags { */
/*     Name = "${var.tag_name}-${var.env_name}-elb-sg" */
/*   } */
/* } */

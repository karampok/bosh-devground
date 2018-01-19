

/* resource "aws_route_table" "bosh" { */
/*   vpc_id = "${aws_vpc.default.id}" */

/*   route { */
/*     cidr_block  = "0.0.0.0/0" */
/*     gateway_id = "${aws_internet_gateway.default.id}" */
/*   } */

/*   tags { */
/*     Name = "${var.tag_name}-${var.env_name}-private-net" */
/*   } */
/* } */

/* resource "aws_route_table_association" "public" { */
/*   subnet_id      = "${aws_subnet.public-net.id}" */
/*   route_table_id = "${aws_route_table.public.id}" */
/* } */





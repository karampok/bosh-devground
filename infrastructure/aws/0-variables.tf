variable "access_key" { }
variable "secret_key" { }
#variable "service_account_email" {}

variable "region" {
  type    = "string"
}

variable "zone" {
  type    = "string"
}

variable "prefix" {
  type = "string"
}

variable "cidr" {
   type = "string"
  default     = "10.10.0.0/16"
}

variable "allowed_ips" {
  type = "string"
}


variable "gw" {
  default     = "10.10.0.1"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}


variable "private_cidr" {
  default     = "10.10.10.0/24"
}

/* variable "public_subnet_cidr" { */
/*   description = "CIDR for bosh subnet" */
/*   default     = "10.10.20.0/24" */
/* } */
/* variable "dns_suffix" { */
/*   type = "string" */
/*   default = "poc" */
/* } */


/* variable "tag" { */
/*   type = "string" */
/* } */


/* variable "bosh_gw" { */
/*   description = "GW for the bosh network" */
/*   default     = "10.0.1.1" */
/* } */

/* variable "bosh_ip" { */
/*   description = "BOSH Director IP" */
/*   default     = "10.0.1.6" */
/* } */

/* Ubuntu amis by region */
/* variable "amis" { */
/*   type        = "map" */
/*   description = "Base AMI to launch the vms" */

/*   default = { */
/*     eu-central-1 = "ami-829145ed" */
/*   } */
/* } */

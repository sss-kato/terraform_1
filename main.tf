provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/24"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {

    Name    = "${var.project}-${var.env}-vpc"
    Project = var.project
    Env     = var.env
  }

}


# Variables
variable "project" {
  type = string
}

variable "env" {
  type = string
}

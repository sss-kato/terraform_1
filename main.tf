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

# Subnet
# Public
resource "aws_subnet" "subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availabilty_zone        = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launce = true

  tags = {
    Name    = "${var.project}-${var.env}-vpc"
    Project = var.project
    Env     = var.env
    Type    = "public"
  }
}

# Public
resource "aws_subnet" "subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availabilty_zone        = "ap-northeast-1c"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launce = true

  tags = {
    Name    = "${var.project}-${var.env}-vpc"
    Project = var.project
    Env     = var.env
    Type    = "public"
  }
}

#Private
resource "aws_subnet" "subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availabilty_zone        = "ap-northeast-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launce = false

  tags = {
    Name    = "${var.project}-${var.env}-vpc"
    Project = var.project
    Env     = var.env
    Type    = "private"
  }
}

#Private
resource "aws_subnet" "subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availabilty_zone        = "ap-northeast-1c"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launce = false

  tags = {
    Name    = "${var.project}-${var.env}-vpc"
    Project = var.project
    Env     = var.env
    Type    = "private"
  }
}

# Variables
variable "project" {
  type = string
}

variable "env" {
  type = string
}

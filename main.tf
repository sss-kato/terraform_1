provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
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
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block             = "192.168.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.env}-public-subnet-1a"
    Project = var.project
    Env     = var.env
    Type    = "public"
  }
}

# Public
resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block             = "192.168.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.env}-public-subnet-1c"
    Project = var.project
    Env     = var.env
    Type    = "public"
  }
}

#Private
resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block             = "192.168.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.env}-private-subnet-1a"
    Project = var.project
    Env     = var.env
    Type    = "private"
  }
}

#Private
resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block             = "192.168.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.env}-private-subnet-1c"
    Project = var.project
    Env     = var.env
    Type    = "private"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}-public-rt"
    Project = var.project
    Env     = var.env
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}-private-rt"
    Project = var.project
    Env     = var.env
    Type    = "public"
  }
}

resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}

# Internet GateWay
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.env}-igw"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_route" "rt_igw" {
  route_table_id          = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw.id
}

# Securiry Group
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-${var.env}-web-sg"
  description = "web servere security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.env}-web-sg"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_security_group_rule" "web_inbound_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "80"
  to_port           = "80"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_inbound_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "443"
  to_port           = "443"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_outbound_db" {
  security_group_id        = aws_security_group.web_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "3306"
  to_port                  = "3306"
  source_security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.env}-db-sg"
  description = "database security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.env}-db-sg"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_security_group_rule" "db_inbound" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "3306"
  to_port                  = "3306"
  source_security_group_id = aws_security_group.web_sg.id
}


# RDS
resource "aws_db_parameter_group" "mysql_parametergroup"{
        name = "${var.project}-${var.env}-mysql"
        family = "mysql8.0"

        parameter{
                name = "character_set_database"
                value = "utf8mb4"
        }

        parameter{
                name = "character_set_server"
                value = "utf8mb4"
        }


}


# Variables
variable "project" {
  type = string
}

variable "env" {
  type = string
}

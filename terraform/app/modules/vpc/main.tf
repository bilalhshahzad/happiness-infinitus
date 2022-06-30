locals {
  applied_tags                              = merge(var.custom_tags, var.base_tags)
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
    cidr_block                              = "10.0.0.0/16"
    enable_dns_hostnames                    = true
    tags                                    = local.applied_tags
}

resource "aws_subnet" "public-a" {
    vpc_id                                  = aws_vpc.this.id
    cidr_block                              = "10.0.1.0/24"
    map_public_ip_on_launch                 = "true"
    availability_zone                       = data.aws_availability_zones.available.names[0] 
    tags                                    = local.applied_tags
}

resource "aws_subnet" "public-b" {
    vpc_id                                  = aws_vpc.this.id
    cidr_block                              = "10.0.2.0/24"
    map_public_ip_on_launch                 = "true"
    availability_zone                       = data.aws_availability_zones.available.names[1]
    tags                                    = local.applied_tags
}


resource "aws_subnet" "private-a" {
    vpc_id                                  = aws_vpc.this.id
    cidr_block                              = "10.0.3.0/24"
    availability_zone                       = data.aws_availability_zones.available.names[0] 
    tags                                    = local.applied_tags
}

resource "aws_subnet" "private-b" {
    vpc_id                                  = aws_vpc.this.id
    cidr_block                              = "10.0.4.0/24"
    availability_zone                       = data.aws_availability_zones.available.names[1]
    tags                                    = local.applied_tags
}

resource "aws_internet_gateway" "this" {
    vpc_id                                  = aws_vpc.this.id
    tags                                    = local.applied_tags
}

resource "aws_eip" "this" {
	 vpc                                    = true
}

resource "aws_nat_gateway" "this" {
  allocation_id                             = aws_eip.this.id
  subnet_id                                 = aws_subnet.public-a.id
}

resource "aws_route_table" "priv_nat_route_table" {
    vpc_id                                  = aws_vpc.this.id
    route {
      cidr_block                            = "0.0.0.0/0"
      gateway_id                            = aws_nat_gateway.this.id
    }
}

resource "aws_route_table" "pub_igw_route_table" {
    vpc_id                                  = aws_vpc.this.id
    route {
      cidr_block                            = "0.0.0.0/0"
      gateway_id                            = aws_internet_gateway.this.id
    }
}

resource "aws_route_table_association" "public-a" {
    subnet_id                               = aws_subnet.public-a.id
    route_table_id                          = aws_route_table.pub_igw_route_table.id
}

resource "aws_route_table_association" "public-b" {
    subnet_id                               = aws_subnet.public-b.id
    route_table_id                          = aws_route_table.pub_igw_route_table.id
}


resource "aws_route_table_association" "private-a" {
    subnet_id                               = aws_subnet.private-a.id
    route_table_id                          = aws_route_table.priv_nat_route_table.id
}

resource "aws_route_table_association" "private-b" {
    subnet_id                               = aws_subnet.private-b.id
    route_table_id                          = aws_route_table.priv_nat_route_table.id
}
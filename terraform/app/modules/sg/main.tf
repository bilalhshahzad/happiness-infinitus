locals {
  applied_tags              = merge(var.custom_tags, var.base_tags)
}

resource "aws_security_group" "website" {
    name                    = format("%s-%s", "wp-web-", formatdate("YYYYMMDDhhmmss",timestamp()))
    description             = "Allow inbound traffic"
    vpc_id                  = var.vpc_id

    ingress {
        from_port           = 22
        to_port             = 22
        protocol            = "tcp"
        cidr_blocks         = ["0.0.0.0/0"]
    }

    ingress {
        from_port           = 80
        to_port             = 80
        protocol            = "tcp"
        cidr_blocks         = ["0.0.0.0/0"]
    }

    ingress {
        from_port           = 443
        to_port             = 443
        protocol            = "tcp"
        cidr_blocks         = ["0.0.0.0/0"]
    }

    egress {
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"]
    }

    tags                    = local.applied_tags
}

resource "aws_security_group" "database" {
    name                    = format("%s-%s", "wp-db-", formatdate("YYYYMMDDhhmmss",timestamp()))
    description             = "Allow inbound traffic"
    vpc_id                  = var.vpc_id

    ingress {
        from_port           = 22
        to_port             = 22
        protocol            = "tcp"
        security_groups     = [aws_security_group.website.id]
    }

    ingress {
        from_port           = 3306
        to_port             = 3306
        protocol            = "tcp"
        security_groups     = [aws_security_group.website.id]
    }

   
    egress {
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"]
    }

    tags                    = local.applied_tags

}

resource "aws_security_group" "efs" {
    name                    = format("%s-%s", "wp-efs-", formatdate("YYYYMMDDhhmmss",timestamp()))
    description             = "Allow inbound traffic"
    vpc_id                  = var.vpc_id

    ingress {
        from_port           = 2049
        to_port             = 2049
        protocol            = "tcp"
        cidr_blocks         = ["0.0.0.0/0"]
    }
   
    egress {
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"]
    }

    tags                    = local.applied_tags
}

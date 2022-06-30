locals {
  applied_tags                            = merge(var.custom_tags, var.base_tags)
}

resource "aws_db_subnet_group" "this" {
  name                                    = format("%s-%s", "wp-subnet-group", formatdate("YYYYMMDDhhmmss",timestamp()))
  description                             = "Our subnets under the mountain"
  subnet_ids                              = [var.subnet_private-a_id, var.subnet_private-b_id]
  tags                                    = local.applied_tags
}


resource "aws_db_instance" "this" {
  depends_on                              = [var.db_depends_on_sg_web]
  identifier                              = "wpdb"
  allocated_storage                       = "10"
  engine                                  = "mysql"
  engine_version                          = "5.7"
  instance_class                          = "db.t2.micro"
  db_name                                 = "wpdb"
  username                                = var.db_user
  password                                = var.db_password
  multi_az                                = "true"
  skip_final_snapshot                     = "true"
  vpc_security_group_ids                  = [var.sg_db_id]
  db_subnet_group_name                    = aws_db_subnet_group.this.id
  tags                                    = local.applied_tags
}
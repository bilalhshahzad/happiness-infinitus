locals {
  applied_tags                    = merge(var.custom_tags, var.base_tags)
}

resource "aws_efs_file_system" "this" {
  creation_token                  = format("%s-%s", "wp-fs-", formatdate("YYYYMMDDhhmmss",timestamp()))
  tags                            = local.applied_tags
}

resource "aws_efs_mount_target" "wordpress-a" {
  file_system_id                  = aws_efs_file_system.this.id
  subnet_id                       = var.subnet_public-a_id
  security_groups                 = [var.sg_efs_id]
}


resource "aws_efs_mount_target" "wordpress-b" {
  file_system_id                  = aws_efs_file_system.this.id
  subnet_id                       = var.subnet_public-b_id
  security_groups                 = [var.sg_efs_id]
}
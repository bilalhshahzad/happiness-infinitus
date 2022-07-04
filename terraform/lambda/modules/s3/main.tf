resource "aws_s3_bucket" "this" {
    bucket = var.bucekt_name
    force_destroy = true
}
provider "aws" {
  region = var.aws_region
}

locals {
  s3_buckets = {
    "a" = {
      "name" = "${random_pet.this.id}-a"
    },
    "b" = {
      "name" = "${random_pet.this.id}-b"
    }
  }

  s3_users = {
    "a" = {
      "name" = "A"
      "namespace" = "/s3/rw/"
      "policy" = "readwrite"
      "bucekt_name" = local.s3_buckets.a.name
    },
    "b" = {
      "name" = "B"
      "namespace" = "/s3/r/"
      "policy" = "readonly"
      "bucekt_name" = local.s3_buckets.b.name
    }
  }
}

module "s3" {
  source                             = "./modules/s3/"
  for_each                           = local.s3_buckets
  bucekt_name                        = each.value.name
}

module "users" {
  source                             = "./modules/users/"
  for_each                           = local.s3_users
  random_pet_id                      = random_pet.this.id
  user_name                          = each.value.name
  namespace                          = each.value.namespace
  policy                             = each.value.policy
  bucekt_name                        = each.value.bucekt_name
}

module "lambda" {
  source                             = "./modules/lambda/"
  random_pet_id                      = random_pet.this.id
  a_bucket_id                        = element(module.s3[*].a.s3_bucket_id, 0)
  b_bucket_id                        = one(module.s3[*].b.s3_bucket_id)
  aws_region                         = var.aws_region
}

resource "random_pet" "this" {
  length = 2
}
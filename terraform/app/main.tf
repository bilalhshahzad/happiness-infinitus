locals {
  base_tags = {
    env                                   = "dev",
    terraform                             = "true"
    provisioner                           = "Gandalf"
  }
  applied_tags                            = merge(var.custom_tags, local.base_tags)
}

terraform {
  required_version                        = ">= 1.2.3"

  required_providers {
    aws = {
      source                              = "hashicorp/aws"
      version                             = ">= 4.20.1"
    }
  }
}

terraform {
   backend "s3" {
    bucket                                = "my-tf-state-bucket-name"
    key                                   = "boomshakalaka/terraform.tfstate"
    region                                = "us-east-1"
  }
}

provider "aws" {
	region                                  = var.aws_region
}

module "wp_vpc" {
  source                                  = "./modules/vpc/"
  base_tags                               = local.applied_tags
}

module "wp_sg" {
  source                                  = "./modules/sg/"
  vpc_id                                  = module.wp_vpc.vpc_id
  base_tags                               = local.applied_tags
}

module "wp_rds" {
  source                                  = "./modules/rds/"
  sg_db_id                                = module.wp_sg.sg_db_id
  db_user                                 = var.db_user
  db_password                             = var.db_password
  subnet_private-a_id                     = module.wp_vpc.subnet_private-a_id
  subnet_private-b_id                     = module.wp_vpc.subnet_private-b_id
  vpc_id                                  = module.wp_vpc.vpc_id
  db_depends_on_sg_web                    = [module.wp_sg.sg_web_obj]
  base_tags                               = local.applied_tags
}

module "wp_lb" {
  source                                  = "./modules/lb/"
  sg_web_id                               = module.wp_sg.sg_web_id
  subnet_public-a_id                      = module.wp_vpc.subnet_public-a_id
  subnet_public-b_id                      = module.wp_vpc.subnet_public-b_id
  vpc_id                                  = module.wp_vpc.vpc_id
  asg_id                                  = module.wp_asg.asg_id
  base_tags                               = local.applied_tags
}

module "wp_efs" {
  source    = "./modules/efs/"
  sg_efs_id                               = module.wp_sg.sg_efs_id
  subnet_public-a_id                      = module.wp_vpc.subnet_public-a_id
  subnet_public-b_id                      = module.wp_vpc.subnet_public-b_id
  base_tags                               = local.applied_tags
}

module "wp_asg" {
  source                                  = "./modules/asg/"
  db_user                                 = var.db_user
  db_password                             = var.db_password
  rdshost                                 = module.wp_rds.rdshost
  efsid                                   = module.wp_efs.efsid
  sg_web_id                               = module.wp_sg.sg_web_id
  subnet_public-a_id                      = module.wp_vpc.subnet_public-a_id
  subnet_public-b_id                      = module.wp_vpc.subnet_public-b_id
  lb_target_group_arn                     = module.wp_lb.lb_target_group_arn
  base_tags                               = local.applied_tags
}
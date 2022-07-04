terraform {
  required_version = ">= 1.2.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.2"
    }
  }

  backend "s3" {
    bucket                                = "gandalf-tfstate-20220701000846124100000001"
    key                                   = "boom/terraform.tfstate"
    region                                = "us-east-1"
  }
}
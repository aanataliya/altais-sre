terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"
    }
  }

  required_version = ">= 1.1.1"
}

provider "aws" {
  profile = "default"
  region  = "${var.region}"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "altais"
  cidr = "${var.cidr}"

  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  tags = {
    Name = "altais"
    Environment = "dev"
  }
}

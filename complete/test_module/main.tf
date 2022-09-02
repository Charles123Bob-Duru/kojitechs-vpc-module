# Child module
terraform {
  required_version = ">=0.14"

  backend "s3" {
    bucket         = "kojitech.3.tier.arch.jnj" # 
    dynamodb_table = "terraform-state-block" # 
    region         = "us-east-1"
    key            = "path/env"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


# module "vpc" {
#   source = "../.." # github url

#   vpc_cidr      = "10.0.0.0/16"
#   public_cidr   = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
#   private_cidr  = ["10.0.1.0/24", "10.0.3.0/24"]
#   database_cidr = ["10.0.5.0/24", "10.0.7.0/24"]
#   vpc_tags = {
#     Name = "Kojitechs_vpc"
#   }
# }

module "vpc" {
  source = "git::https://github.com/Charles123Bob-Duru/kojitechs-vpc-module.git?ref=v1.0.0" 

  vpc_cidr      = "10.0.0.0/16"
  public_cidr   = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
  private_cidr  = ["10.0.1.0/24", "10.0.3.0/24"]
  database_cidr = ["10.0.5.0/24", "10.0.7.0/24"]
  vpc_tags = {
    Name = "Kojitechs_vpc"
  }
}

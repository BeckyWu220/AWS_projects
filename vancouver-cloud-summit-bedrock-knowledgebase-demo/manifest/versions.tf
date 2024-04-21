terraform {
  required_version = "~> 1.7.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}


provider "null" {
  # Configuration options
}
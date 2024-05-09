provider "aws" {
  default_tags {
    tags = local.tags
  }
  region = var.aws_region
  profile = var.aws_profile
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = module.eks.cluster_arn
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.2"
    }
  }

  required_version = ">= 1.4.2"
}

variable "aws_region" {
  description = "Default AWS Region"
  type = string
}

variable "aws_profile" {
    description = "Default AWS Profile Name"
    type = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-workshop"
}

variable "cluster_version" {
  description = "EKS cluster version."
  type        = string
  default     = "1.29"
}

variable "ami_release_version" {
  description = "Default EKS AMI release version for node groups"
  type        = string
  default     = "1.29.0-20240129"
}

variable "vpc_cidr" {
  description = "Defines the CIDR block used on Amazon VPC created for Amazon EKS."
  type        = string
  default     = "10.42.0.0/16"
}

variable "git_repo_url" {
  type = string
  description = "Git repo URL that ArgoCD application will use to deploy the application"
}

variable "git_revision" {
  type = string
  description = "Git revision to use for the application. In case of Git, this can be commit, tag, or branch. "
  default = "HEAD"
}

variable "git_path" {
  type = string
  description = "Path to the application in the git repository"
  default = ""
}
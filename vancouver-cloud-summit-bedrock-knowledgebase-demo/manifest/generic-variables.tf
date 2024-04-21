variable "aws_region" {
  description = "Default AWS Region"
  type = string
}

variable "aws_profile" {
  description = "Default AWS Profile Name"
  type = string
}

variable "env" {
  description = "Environment Name"
  type = string
  default = "dev"
}

variable "create_bucket" {
  type = bool
  description = "Set to true if you need to create a S3 bucket for storing knowledge base content."
  default = false
}
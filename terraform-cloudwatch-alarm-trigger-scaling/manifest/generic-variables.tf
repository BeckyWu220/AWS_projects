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
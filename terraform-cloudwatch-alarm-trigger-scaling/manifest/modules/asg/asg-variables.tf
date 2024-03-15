variable "asg_launch_template_name" {
  description = "Launch Template Name"
  type = string
  default = "launch-template"
}

variable "asg_name" {
  description = "ASG Name"
  type = string
  default = "asg"
}

variable "instance_keypair" {
  description = "EC2 Key Pair Name"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t2.micro"
}
# Get latest AMI ID for Amz Linux2 OS
data "aws_ami" "amz-linux2-ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-gp2"] # the AMI name is different from AMI ID that usually start with "ami-"
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}
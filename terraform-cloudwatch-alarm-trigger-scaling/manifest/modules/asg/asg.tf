# Launch Template
resource "aws_launch_template" "asg_launch_template" {
  name = var.asg_launch_template_name
  description = "Launch Template for Instances"
  image_id = data.aws_ami.amz-linux2-ami.id
  instance_type = var.instance_type
}

# ASG
resource "aws_autoscaling_group" "asg" {
  name = var.asg_name
  desired_capacity = 2
  max_size = 5
  min_size = 1

  health_check_type = "EC2"
  health_check_grace_period = 300

  launch_template {
   id = aws_launch_template.asg_launch_template.id
   version = aws_launch_template.asg_launch_template.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    # 'launch_template' always triggers an instance refresh
    triggers = [ "desired_capacity" ] 
  }
}
# Use local module to provision an ASG or Import your own into Terraform
module "asg" {
    source = "./modules/asg"
    instance_keypair = var.instance_keypair
}

resource "aws_autoscaling_policy" "scalingpolicy_high_cpu" {
  name                   = "High-CPU-ScalingPolicy"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg.asg_name
}
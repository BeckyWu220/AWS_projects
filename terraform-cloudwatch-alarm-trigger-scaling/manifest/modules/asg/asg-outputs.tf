output "asg_name" {
    description = "ASG Name"
    value = aws_autoscaling_group.asg.name
}
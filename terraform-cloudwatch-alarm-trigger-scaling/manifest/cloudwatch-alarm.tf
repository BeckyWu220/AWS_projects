resource "aws_cloudwatch_metric_alarm" "asg_cloudwatch_alarm_cpu" {
  alarm_name                = "ASG-CloudWatch-Alarm-CPUUtilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  
  dimensions = {
    AutoScalingGroupName    = module.asg.asg_name
  }

  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [aws_autoscaling_policy.scalingpolicy_high_cpu.arn]
}
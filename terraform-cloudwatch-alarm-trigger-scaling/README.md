# Terraform Demo of triggering Auto Scaling through CloudWatch Alarms

Note: This project is built base on the assumption that you've have an ASG in place. If you don't, provision one using local module, `asg`, before moving on, or importing an ASG that you have into Terraform. 

## Terraform Modules used:
[terraform-aws-modules/cloudwatch](https://registry.terraform.io/modules/terraform-aws-modules/cloudwatch/aws/latest),

## Important Steps:
1. Create CloudWatch Alarm in conjunction with Scaling Policies
- Create `aws_cloudwatch_metric_alarm` type resource of "CPUUtilization" metric and set threshold for it. Associate the metric with `asg` ASG.  
`cloudwatch-alarm.tf`
- Create Scaling Policy to be triggered in corresponding to the CloudWatch alarm.
`asg-scalingpolicy.tf`

- CIS(Center for Internet Security) Alarms.




----
## To-do:
* Provision SNS Topic to receive notifications. 
* Enable CIS alarms.
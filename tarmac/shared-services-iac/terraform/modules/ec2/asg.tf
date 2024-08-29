##
# Autoscaling group
##
resource "aws_autoscaling_group" "main" {
  count                     = local.default
  name_prefix               = "asg-${var.app}-${var.env}-${aws_launch_template.app[count.index].latest_version}-"
  desired_capacity          = var.asg_desired
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  min_elb_capacity          = var.asg_min
  default_instance_warmup   = 180
  health_check_grace_period = 600
  health_check_type         = "EC2"

  vpc_zone_identifier = var.associate_public_ip_address ? [
    for az in data.aws_subnet.public : az.id
    ] : [
    for az in data.aws_subnet.private : az.id
  ]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  launch_template {
    id      = aws_launch_template.app[count.index].id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.app}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.tags["Environment"]
    propagate_at_launch = true
  }
  tag {
    key                 = "App"
    value               = var.tags["App"]
    propagate_at_launch = true
  }
  tag {
    key                 = "Resource"
    value               = var.tags["Resource"]
    propagate_at_launch = true
  }
  tag {
    key                 = "Description"
    value               = var.tags["Description"]
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

##
# Autoscaling policies and Cloudwatch alarms
##

# Scale on CPU
resource "aws_autoscaling_policy" "high_cpu" {
  count = local.default

  name                   = "${var.app}-${var.env}-high-cpu-scaleup"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main[count.index].name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = local.default

  alarm_name          = "${var.app}-${var.env}-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main[count.index].name
  }

  alarm_description = "CPU usage for ${aws_autoscaling_group.main[count.index].name} ASG"
  alarm_actions     = [aws_autoscaling_policy.high_cpu[count.index].arn]
}

resource "aws_autoscaling_policy" "low_cpu" {
  count = local.default

  name                   = "${var.app}-${var.env}-low-cpu-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main[count.index].name
}

resource "aws_cloudwatch_metric_alarm" "low-cpu" {
  count = local.default

  alarm_name          = "${var.app}-${var.env}-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "35"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main[count.index].name
  }

  alarm_description = "CPU usage for ${aws_autoscaling_group.main[count.index].name} ASG"
  alarm_actions     = [aws_autoscaling_policy.low_cpu[count.index].arn]
}

##
# Autoscaling notifications
##
resource "aws_autoscaling_notification" "asg_notifications" {
  count = local.default

  group_names = [
    aws_autoscaling_group.main[count.index].name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]

  topic_arn = aws_sns_topic.sns[count.index].arn
}

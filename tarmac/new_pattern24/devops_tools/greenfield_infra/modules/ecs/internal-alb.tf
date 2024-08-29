resource "aws_lb" "i-alb_ecs" {
  name                       = "i-alb-${var.name}-${var.tags["env"]}"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg-i-alb-ecs.id]
  subnets                    = var.subnets
  idle_timeout               = "600"
  enable_deletion_protection = true

  # access_logs {
  #   bucket        = "pillar-${var.tags["act"]}-lb-logs-eu-west-2-${data.aws_caller_identity.current.account_id}"
  #   prefix        = "ecs/i-alb-ecs-services"
  #   #enabled       = true
  # }

}
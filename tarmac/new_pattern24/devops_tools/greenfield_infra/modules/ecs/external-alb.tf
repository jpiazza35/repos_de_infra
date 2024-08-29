resource "aws_lb" "alb_ecs" {
  name                       = "alb-${var.name}-${var.tags["env"]}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg-alb-ecs.id]
  subnets                    = var.subnets
  idle_timeout               = "600"
  enable_deletion_protection = true

  # Access logs if needed:

  # access_logs {
  #   bucket        = "greenfield-${var.tags["act"]}-lb-logs-eu-west-2-${data.aws_caller_identity.current.account_id}"
  #   prefix        = "ecs/alb-ecs-services"
  #   #enabled       = true
  # }

}
######PHPIPAM

resource "aws_alb" "load_balancer" {
  count              = local.default
  name               = format("%s-lb", lower(var.env))
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids

  security_groups = [
    aws_security_group.load_balancer_security_group[count.index].id,
  ]
  enable_deletion_protection = false
  internal                   = false
  access_logs {
    bucket  = aws_s3_bucket.logs[count.index].id
    prefix  = "ss-lb"
    enabled = true
  }
}

resource "aws_security_group" "load_balancer_security_group" {
  count  = local.default
  vpc_id = var.vpc_id
  name   = format("%s-lb-sg", lower(var.env))
  ingress {
    description = "Self from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "HTTPS Incident Bot Ingress"
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }

  egress {
    description = "all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.vpc_cidr,
      "0.0.0.0/0"
    ]
  }

  lifecycle {
    ignore_changes = [
      ingress
    ]
  }

  tags = merge(
    var.tags,
    {
      Name           = format("%s-lb-sg", lower(var.env))
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

resource "aws_lb_listener" "listener" {
  count             = local.default
  load_balancer_arn = aws_alb.load_balancer[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.acm_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task[format("%s-alb-tg", lower(var.env))].arn
  }

}

resource "aws_lb_target_group" "task" {
  for_each = var.load_balanced && terraform.workspace == "sharedservices" ? {
    for tg in var.target_groups : tg.target_group_name => tg
    if tg.target_group_name == format("%s-alb-tg", lower(var.env))
  } : {}

  name                 = format("%s-alb-tg", lower(var.env))
  vpc_id               = var.vpc_id
  protocol             = var.task_container_protocol
  port                 = lookup(each.value, "container_port", var.task_container_port)
  deregistration_delay = lookup(each.value, "deregistration_delay", null)
  target_type          = "ip"


  dynamic "health_check" {
    for_each = [var.health_check]
    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      protocol            = lookup(health_check.value, "protocol", null)
      timeout             = lookup(health_check.value, "timeout", 2)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name           = lookup(each.value, "target_group_name")
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )
}


########## Sonatype ALB

resource "aws_alb" "load_balancer_sonatype" {
  name               = "alb-sonatype"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids

  security_groups = [
    aws_security_group.sonatype_load_balancer_security_group.id
  ]
  enable_deletion_protection = true
  internal                   = false
  access_logs {
    bucket  = aws_s3_bucket.logs[0].id
    prefix  = "ss-sonatype-lb"
    enabled = true
  }
  drop_invalid_header_fields = true
}

resource "aws_security_group" "sonatype_load_balancer_security_group" {
  description = "Sonatype Load Balancer Security Group"
  vpc_id      = var.vpc_id
  name        = format("%s-lb-sonatype-sg", lower(var.env))
  ingress {
    description = "Self from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "HTTPS 8082 docker"
    from_port   = 8082
    to_port     = 8082
    protocol    = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    description = "all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.vpc_cidr,
      "0.0.0.0/0"
    ]
  }

  lifecycle {
    ignore_changes = [
      ingress
    ]
  }

  tags = merge(
    var.tags,
    {
      Name           = format("%s-lb-sonatype-sg", lower(var.env))
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

resource "aws_lb_listener" "sonatype_listener" {
  load_balancer_arn = aws_alb.load_balancer_sonatype.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.sonatype_acm_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonatype_task_tg.arn
  }
}

resource "aws_lb_target_group" "sonatype_task_tg" {

  name                 = "ss-alb-sonatype-tg"
  vpc_id               = var.vpc_id
  protocol             = var.task_container_protocol
  port                 = var.sonatype_task_container_port
  deregistration_delay = 10
  target_type          = "ip"


  health_check {
    port                = "8081"
    path                = "/"
    enabled             = true
    interval            = 60
    timeout             = 50
    healthy_threshold   = 2
    unhealthy_threshold = 8
    protocol            = "HTTP" #"TCP" #
    matcher             = "200,302"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name           = "UI target group"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

resource "aws_lb_listener" "sonatype_listener_2" {
  load_balancer_arn = aws_alb.load_balancer_sonatype.arn
  port              = "8082"
  protocol          = "HTTPS"
  certificate_arn   = var.sonatype_acm_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonatype_task_tg_2.arn
  }
}

resource "aws_lb_target_group" "sonatype_task_tg_2" {
  name                 = "ss-alb-sonatype-tg-2"
  vpc_id               = var.vpc_id
  protocol             = var.task_container_protocol
  port                 = "8082"
  deregistration_delay = 10
  target_type          = "ip"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name           = "Docker Registry Target Group"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}


########## INCIDENT BOT ALB

resource "aws_lb_listener" "incident_bot_listener" {
  count             = local.default
  load_balancer_arn = aws_alb.load_balancer[count.index].arn
  port              = "3000"
  protocol          = "HTTPS"
  certificate_arn   = var.incident_bot_acm_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.incident_bot_task_tg[count.index].arn
  }
}

resource "aws_lb_target_group" "incident_bot_task_tg" {
  count = local.default

  name                 = "ss-alb-incident-bot-tg"
  vpc_id               = var.vpc_id
  protocol             = var.task_container_protocol
  port                 = var.incident_bot_task_container_port
  deregistration_delay = 10
  target_type          = "ip"


  health_check {
    port                = "3000"
    path                = "/"
    enabled             = true
    interval            = 60
    timeout             = 50
    healthy_threshold   = 2
    unhealthy_threshold = 8
    protocol            = "HTTP" #"TCP" #
    matcher             = "200,302"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name           = "ss-alb-incident-bot-tg"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

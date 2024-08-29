resource "aws_security_group" "ecs_security_group" {
  name   = "ecs-services-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = var.config_services.service-name.taskDefinitionValues.container_port
    to_port   = var.config_services.service-name.taskDefinitionValues.container_port
    self      = true
    security_groups = [
      aws_security_group.external_lb_sg.id
    ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Backend Service Load Balancer Config
resource "aws_security_group" "external_lb_sg" {
  name   = "ecs-external-lb-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

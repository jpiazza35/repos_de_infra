resource "aws_eip" "lb" {
  for_each = var.alb["create_static_public_ip"] ? toset(var.alb["subnets"] == null ? local.subnets : var.alb["subnets"]) : toset([])

  domain = "vpc"

  tags = {
    Name           = format("%s-%s-%s-lb-ip", lower(var.alb["env"]), lower(var.alb["app"]), each.key)
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}

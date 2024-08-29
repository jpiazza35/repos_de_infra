resource "aws_eip" "lb" {
  for_each = var.lb["create_static_public_ip"] ? toset(var.lb["subnets"] == null ? local.subnets : var.lb["subnets"]) : toset([])

  domain = "vpc"

  tags = {
    Name           = format("%s-%s-%s-lb-ip", lower(var.lb["env"]), lower(var.lb["app"]), each.key)
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}

resource "aws_lb" "load_balancer" {
  name = format("%s-%s-lb", lower(var.lb["env"]), lower(var.lb["app"]))

  load_balancer_type = var.lb["load_balancer_type"]

  dynamic "subnet_mapping" {
    for_each = toset(var.lb["subnets"] == null ? local.subnets : var.lb["subnets"])

    content {
      subnet_id     = subnet_mapping.value
      allocation_id = var.lb["create_static_public_ip"] ? aws_eip.lb[subnet_mapping.key].id : null
    }

  }

  security_groups = var.lb["create_security_group"] ? concat(
    var.lb["security_group"]["ids"],
    [
      aws_security_group.load_balancer_security_group.id
  ]) : []

  enable_deletion_protection = var.lb["enable_deletion_protection"]

  enable_cross_zone_load_balancing = var.lb["load_balancer_type"] == "network" ? var.lb["enable_cross_zone_load_balancing"] : false

  internal = var.lb["internal"]

  dynamic "access_logs" {
    for_each = var.lb["access_logs"]["enabled"] ? [var.lb["access_logs"]] : []
    content {
      bucket  = var.lb["access_logs"]["bucket"] == "" ? aws_s3_bucket.logs[0].id : var.lb["access_logs"]["bucket"]
      prefix  = var.lb["access_logs"]["prefix"] == "" ? format("%s-lb", var.lb["app"]) : var.lb["access_logs"]["prefix"]
      enabled = var.lb["access_logs"]["enabled"]
    }
  }

  tags = merge(
    {
      Name = format("%s-%s-lb", lower(var.lb["env"]), lower(var.lb["app"]))
    },
    var.lb["tags"],
    {
      Environment    = var.lb["env"]
      App            = var.lb["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.lb["app"]} Related Configuration"
      Team           = var.lb["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

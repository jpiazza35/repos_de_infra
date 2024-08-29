# Workspace validator
resource "null_resource" "tf_workspace_validator" {
  lifecycle {
    precondition {
      condition     = (terraform.workspace == "tgw" && data.aws_region.current.name == "us-east-1") || (terraform.workspace == "tgw-ohio" && data.aws_region.current.name == "us-east-2")
      error_message = "SANITY CHECK: This is a sensitive project. Your current workspace is '${terraform.workspace}'. You must be in the 'tgw' or 'tgw-ohio' workspace and export the appropriate aws region to apply this terraform."
    }
  }
}

resource "aws_ec2_transit_gateway" "tgw" {
  description                     = coalesce(var.description, var.name)
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  multicast_support               = var.enable_mutlicast_support ? "enable" : "disable"
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = var.enable_dns_support ? "enable" : "disable"
  transit_gateway_cidr_blocks     = var.transit_gateway_cidr_blocks

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  tags = merge(
    var.tags,
    {
      Name                               = var.name
      "com.amazonaws.dx.resiliencecheck" = "disabled"
      sourcecodeRepo                     = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}

# Tag the default route table
resource "aws_ec2_tag" "tgw-rtb" {
  for_each = {
    for k, v in var.tags : k => v
    if var.enable_default_route_table_association
  }

  resource_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
  key         = each.key
  value       = each.value
}

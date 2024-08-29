# Tag default route table
resource "aws_ec2_tag" "default_rtb" {
  resource_id = aws_vpc.vpc.default_route_table_id
  for_each = merge(
    var.tags,
    {
      Name           = format("%s-default-local-only", aws_vpc.vpc.tags["Name"])
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
  key   = each.key
  value = each.value
}

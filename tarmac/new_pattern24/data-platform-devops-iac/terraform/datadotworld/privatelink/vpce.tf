resource "aws_vpc_endpoint_service" "data_dot_world" {
  acceptance_required = true
  network_load_balancer_arns = [
    module.nlb_data_dot_world.arn
  ]
  allowed_principals = [
    "arn:aws:iam::${var.data_dot_world_aws_account_id}:root"
  ]

  supported_ip_address_types = [
    "ipv4"
  ]
  tags = merge(
    var.tags,
    {
      Name        = format("%s-vpce-service", local.prefix)
      Environment = var.env
      Component   = "${title(var.app)} Infrastructure"
    }
  )
}

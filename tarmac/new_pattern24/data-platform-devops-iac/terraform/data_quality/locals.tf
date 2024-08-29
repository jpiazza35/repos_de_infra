# locals {
#   prefix = format("%s-%s", var.lb_env, var.lb_app)

#   ingress_rules = [for key, value in var.routes : {
#     description = format("data quality access to %s", key)
#     from_port   = value.listener.port
#     to_port     = value.listener.port
#     protocol    = "TCP"
#     cidr_blocks = [
#       var.data_quality_cidr
#     ]
#     }
#   ]
# }
locals {
  targets = [
    for vpce in data.aws_network_interface.s3 : {
      id   = vpce.private_ip
      port = 443
    }
  ]

}

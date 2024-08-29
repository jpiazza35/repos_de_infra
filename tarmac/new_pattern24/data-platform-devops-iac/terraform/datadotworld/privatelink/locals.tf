locals {
  prefix = format("%s-%s", var.env, var.app)

  ingress_rules = [for key, value in var.routes : {
    description = format("data world access to %s", key)
    from_port   = value.listener.port
    to_port     = value.listener.port
    protocol    = "TCP"
    cidr_blocks = [
      var.data_dot_world_cidr
    ]
    }
  ]
}

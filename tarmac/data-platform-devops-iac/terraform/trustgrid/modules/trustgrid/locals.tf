locals {
  lt_name          = "lt-${var.app}-${var.env}-"
  asg_name         = "asg-${var.app}-${var.env}"
  sns_name         = "sns-${var.app}-${var.env}"
  sns_display_name = "${title(var.app)} ${title(var.env)} ASG SNS Topic"

  ni_id = [
    for s in aws_network_interface.public_ni : s.id
  ]

  additional_sg_rules = flatten([
    for rule in var.additional_sg_rules : [
      for cidr_block in rule.cidr_blocks : {
        type        = rule.type
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        description = rule.description
        cidr_block  = cidr_block
      }
    ]
  ])

}

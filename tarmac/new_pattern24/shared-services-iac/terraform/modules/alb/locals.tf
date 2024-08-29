locals {
  subnets = var.alb["internal"] ? data.aws_subnets.private.ids : data.aws_subnets.public.ids

  tgs = [
    for tg in var.alb["target_groups"] : "${lower(tg.protocol)}-${tg.port}"
  ]

  targets = flatten([
    for tg in var.alb["target_groups"] : flatten([
      for t in tg.targets : {
        key  = "${lower(tg.protocol)}-${tg.port}"
        id   = t.id
        port = t.port
      }
    ])
    if tg.enable_lb_target_group_attachment
  ])

}

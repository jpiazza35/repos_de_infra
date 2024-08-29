locals {
  subnets = var.alb["internal"] ? data.aws_subnets.private.ids : data.aws_subnets.public.ids

  tgs = [
    for tg in var.alb["target_groups"] : "${lower(tg.protocol)}-${tg.port}"
  ]

}

locals {
  subnets = var.lb["internal"] ? data.aws_subnets.private.ids : data.aws_subnets.public.ids
}

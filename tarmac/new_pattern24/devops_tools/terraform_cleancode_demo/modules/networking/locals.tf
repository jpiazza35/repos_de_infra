locals {
  subnets = [
    for sg in var.args.subnet_groups : [
      for az in var.args.availability_zones : {
        subnet_group      = sg
        availability_zone = "${var.args.region}${az}"
        zone_letter       = az
      }
    ]
  ]

  flat_subnets = flatten(local.subnets)
}
locals {
  count = (terraform.workspace == "preview" || terraform.workspace == "dev" || terraform.workspace == "prod" || terraform.workspace == "sdlc") ? 1 : 0

  vpc_cidr = format("%s/%s", element(data.phpipam_subnet.databricks[*].subnet_address, 0), element(data.phpipam_subnet.databricks[*].subnet_mask, 0))

  private_subnet_ids_az = [
    for k, v in data.aws_subnets.private_per_az : v.ids[0]
  ]

  local_subnet_ids_az = [
    for k, v in data.aws_subnets.local_per_az : v.ids[0]
  ]
}

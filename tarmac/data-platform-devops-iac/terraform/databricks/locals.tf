locals {
  count = (terraform.workspace == "dev" || terraform.workspace == "prod" || terraform.workspace == "sdlc") ? 1 : 0

  vpc_cidr = format("%s/%s", element(data.phpipam_subnet.databricks[*].subnet_address, 0), element(data.phpipam_subnet.databricks[*].subnet_mask, 0))

}


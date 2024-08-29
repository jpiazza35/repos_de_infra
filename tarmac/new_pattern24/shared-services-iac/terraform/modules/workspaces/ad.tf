resource "aws_directory_service_directory" "ds" {
  description = "Clinician Nexus AWS Directory Service"
  name        = var.domain_name
  password    = data.vault_generic_secret.ds_password.data["sa_password"]
  size        = var.ds_size

  # alias                                = var.enable_sso ? var.app : null
  short_name = var.domain_short_name
  enable_sso = var.enable_sso
  type       = var.ds_type
  connect_settings {

    customer_username = data.vault_generic_secret.ds_password.data["sa_username"]
    customer_dns_ips  = var.dc_ips
    subnet_ids = [
      data.aws_subnets.private.ids[0],
      data.aws_subnets.private.ids[1]
    ]
    vpc_id = data.aws_vpc.vpc.id

  }

  dynamic "vpc_settings" {
    for_each = var.ds_type != "ADConnector" ? toset([1]) : toset([])
    content {
      vpc_id     = data.aws_vpc.vpc.id
      subnet_ids = data.aws_subnets.private.ids
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.app
    }
  )

}


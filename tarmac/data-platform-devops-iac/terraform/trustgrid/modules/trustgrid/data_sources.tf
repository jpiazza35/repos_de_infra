data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "vpc" {

  filter {
    name = "tag:Name"
    values = [
      "primary-vpc"
    ]
  }
}

data "aws_subnets" "public" {

  filter {
    name = "tag:Layer"
    values = [
      "public"
    ]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_subnets" "private" {

  filter {
    name = "tag:Layer"
    values = [
      "private"
    ]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_ami" "trustgrid" {

  most_recent = true

  filter {
    name   = "name"
    values = ["trustgrid-agent*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["079972220921"] # Canonical
}

data "template_cloudinit_config" "server_config" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/user_data/cloud_init.yml", {
      prefix  = format("%s-%s", var.app, var.env)
      region  = data.aws_region.current.name
      license = jsondecode(data.aws_secretsmanager_secret_version.license.secret_string)["primary"]
    })
  }
}

data "template_cloudinit_config" "server_config_secondary" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/user_data/cloud_init.yml", {
      prefix  = format("%s-%s-secondary", var.app, var.env)
      region  = data.aws_region.current.name
      license = jsondecode(data.aws_secretsmanager_secret_version.license.secret_string)["secondary"]
    })
  }
}

data "aws_secretsmanager_secret" "license" {
  name = "trustgrid-license"
}

data "aws_secretsmanager_secret_version" "license" {
  secret_id = data.aws_secretsmanager_secret.license.id
}

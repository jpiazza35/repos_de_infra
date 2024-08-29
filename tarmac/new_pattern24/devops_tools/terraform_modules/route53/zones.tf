resource "aws_route53_zone" "public" {
  count   = var.create_main_dns_resources ? 1 : 0
  name    = var.main_public_dns
  comment = "The main public example-account-cloud-payment DNS zone."

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Environment"]}-${var.tags["Product"]}-public-r53-zone"
    },
  )
}

resource "aws_route53_zone" "env_public" {
  count   = var.create_env_dns_resources ? length(var.environments) : 0
  name    = "${var.environments[count.index]}.${var.main_public_dns}"
  comment = "The DNS zone per environment (${var.environments[count.index]})."

  tags = merge(
    var.tags,
    {
      Name = "${var.environments[count.index]}-public-r53-zone"
    },
  )
}

resource "aws_route53_zone" "apps_public" {
  count   = var.create_apps_dns_resources ? 1 : 0
  name    = var.app_public_dns
  comment = "The public example-account-cloud-payment DNS zone per application."

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Environment"]}-${var.tags["Application"]}-public-r53-zone"
    },
  )
}

resource "aws_route53_zone" "ds_public" {
  count   = var.create_ds_dns_resources ? 1 : 0
  name    = var.ds_public_dns
  comment = "The public example-account-cloud-payment DS DNS zone."

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Environment"]}-ds-public-r53-zone"
    },
  )
}

resource "aws_route53_zone" "internal" {
  count   = var.create_dns_resources ? 1 : 0
  name    = "${var.tags["Environment"]}.${var.private_dns}"
  comment = "Internal DNS zone to use within services"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Environment"]}-${var.tags["Product"]}-private-r53-zone"
    },
  )
}

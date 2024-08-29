resource "aws_route53_zone" "phz" {
  name    = var.private_dns # private r53 zone
  comment = "internal zone to register all instances with"
  vpc {
    vpc_id = aws_vpc.vpc.id
  }

  tags = {
    Name       = "${var.private_dns == "" ? "${var.project}-${var.tags["vpc"]}.phz" : var.private_dns}"
    CostCentre = "${var.tags["costcentre"]}"
    Env        = "${var.tags["env"]}"
    Function   = "DNS zone"
    Repository = "${var.tags["repository"]}"
    Script     = "${var.tags["script"]}"
    Service    = "${var.tags["service"]}"
  }
}

resource "aws_route53_zone" "public" {
  name    = var.public_dns # public r53 zone
  comment = "external zone"

  tags = {
    Env        = "${var.tags["env"]}"
    Function   = "DNS zone"
    Repository = "${var.tags["repository"]}"
    Script     = "${var.tags["script"]}"
    Service    = "${var.tags["service"]}"
  }
}

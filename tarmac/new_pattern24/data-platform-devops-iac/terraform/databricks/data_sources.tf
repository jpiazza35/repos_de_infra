data "aws_caller_identity" "current" {
  count = local.count
}
// Get VPC CIDR Information from phpIPam and acct
data "phpipam_section" "section" {
  count = local.count
  name  = "SullivanCotter"
}

data "phpipam_subnet" "databricks" {
  count             = local.count
  section_id        = data.phpipam_section.section[count.index].id
  description_match = terraform.workspace == "preview" ? "S_DATABRICKSS" : terraform.workspace == "sdlc" ? "SS_DATABRICKS" : var.aws_acct_name
}

// Get VPC Information from AWS
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name = "zone-id"
    values = [
      "use1-az1",
      "use1-az5",
      "use1-az6"
    ]
  }
}

data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = [
      "primary-vpc"
    ]
  }

}

// Get Private Subnets from AWS
data "aws_subnets" "private" {
  #  count = local.count
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.selected.id
    ]
  }

  tags = {
    Layer = "private"
  }
}

data "aws_subnets" "private_per_az" {
  for_each = toset(data.aws_availability_zones.available.names)
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.selected.id
    ]
  }
  filter {
    name   = "availability-zone"
    values = ["${each.value}"]
  }
  tags = {
    Layer = "private"
  }
}

data "aws_subnet" "private_subnet" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

// Get Local Subnets from AWS
data "aws_subnets" "local" {
  #  count = local.count
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.selected.id
    ]
  }

  tags = {
    Layer = "databricks"
  }
}

data "aws_subnets" "local_per_az" {
  for_each = toset(data.aws_availability_zones.available.names)
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.selected.id
    ]
  }
  filter {
    name   = "availability-zone"
    values = ["${each.value}"]
  }
  tags = {
    Layer = "databricks"
  }
}

// Get SG Information from AWS
data "aws_security_groups" "private" {
  count = local.count

  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.selected.id
    ]
  }
}

// Get Databricks Credentials from AWS Secrets Manager
data "aws_secretsmanager_secret" "databricks" {
  count = local.count
  name  = "databricks"
}

data "aws_secretsmanager_secret_version" "databricks" {
  count     = local.count
  secret_id = data.aws_secretsmanager_secret.databricks[count.index].id
}

data "aws_secretsmanager_secret" "secret" {
  provider = aws.sstools
  count    = local.count
  name     = "phpIPAM"
}

data "aws_secretsmanager_secret_version" "secret" {
  provider  = aws.sstools
  count     = local.count
  secret_id = data.aws_secretsmanager_secret.secret[count.index].id
}

// Get VPC Information from AWS
data "aws_vpcs" "ss_network" {
  provider = aws.ss_network
  count    = local.count
  tags = {
    Name = "*-vpc"
  }

}

data "aws_vpc" "ss_network" {
  provider = aws.ss_network
  count    = length(data.aws_vpcs.ss_network[0].ids)
  id       = tolist(data.aws_vpcs.ss_network[0].ids)[count.index]
}

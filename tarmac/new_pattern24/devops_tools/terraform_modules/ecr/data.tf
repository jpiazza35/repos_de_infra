data "aws_caller_identity" "current" {
}
data "template_file" "ecr_read_write_access" {
  template = file("${path.module}/iam_policies/ecr_read_write_access.json")
}

data "template_file" "ecr_read_write_access_prod" {
  template = file("${path.module}/iam_policies/ecr_read_write_access_prod.json")

  vars = {
    prod_ecr_vpc_endpoint     = var.prod_ecr_vpc_endpoint
    prod_ecr_api_vpc_endpoint = var.prod_ecr_api_vpc_endpoint
    organization_id           = "Your-Org-ID"
  }
}

data "template_file" "ecr_read_write_access_ecea_prod" {
  template = file("${path.module}/iam_policies/ecr_read_write_access_ecea_prod.json")

  vars = {
    prod_ecea_ecr_dkr_vpc_endpoint = var.prod_ecea_ecr_dkr_vpc_endpoint
    prod_ecea_ecr_api_vpc_endpoint = var.prod_ecea_ecr_api_vpc_endpoint
    organization_id                = "Your-Org-ID"
  }
}

data "template_file" "ecr_read_write_access_da_prod" {
  template = file("${path.module}/iam_policies/ecr_read_write_access_da_prod.json")

  vars = {
    prod_ecr_vpc_endpoint     = var.prod_ecr_vpc_endpoint
    prod_ecr_api_vpc_endpoint = var.prod_ecr_api_vpc_endpoint
    organization_id           = "Your-Org-ID"
  }
}

data "template_file" "ecr_readonly" {
  template = file("${path.module}/iam_policies/ecr_readonly.json")
}

data "template_file" "rundeck_ecr" {
  template = file("${path.module}/iam_policies/rundeck_ecr.json")
}

data "template_file" "ecr_lifecycle_policy" {
  template = file("${path.module}/iam_policies/ecr_lifecycle_policy.json")
}

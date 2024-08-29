resource "aws_organizations_account" "dtcloud_proxy_dev" {
  name      = "dtcloud-proxy-dev"
  email     = "dtcloud-aws+proxy-dev@datatrans.ch"
  parent_id = aws_organizations_organizational_unit.product.id
}

resource "aws_organizations_account" "dtcloud_proxy_test" {
  name      = "dtcloud-proxy-test"
  email     = "dtcloud-aws+proxy-test@datatrans.ch"
  parent_id = aws_organizations_organizational_unit.product.id
}

resource "aws_organizations_account" "dtcloud_proxy_prod" {
  name      = "dtcloud-proxy-prod"
  email     = "dtcloud-aws+proxy-prod@datatrans.ch"
  parent_id = aws_organizations_organizational_unit.product.id
}
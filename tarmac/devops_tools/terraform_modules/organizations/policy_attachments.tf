resource "aws_organizations_policy_attachment" "product_fsPKWB" {
  policy_id = aws_organizations_policy.guardrails_fsPKWB.id
  target_id = aws_organizations_organizational_unit.product.id
}

resource "aws_organizations_policy_attachment" "core_yBOtDK" {
  policy_id = aws_organizations_policy.guardrails_yBOtDK.id
  target_id = aws_organizations_organizational_unit.core.id
}

resource "aws_organizations_policy_attachment" "core_DsKlqh" {
  policy_id = aws_organizations_policy.guardrails_DsKlqh.id
  target_id = aws_organizations_organizational_unit.core.id
}

resource "aws_organizations_policy_attachment" "shared_HHmslj" {
  policy_id = aws_organizations_policy.guardrails_HHmslj.id
  target_id = aws_organizations_organizational_unit.shared.id
}

resource "aws_organizations_policy_attachment" "root" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_policy_attachment" "example-account_master" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.example-account_master.id
}

resource "aws_organizations_policy_attachment" "example-account_logging_monitoring" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.example-account_logging_monitoring.id
}

resource "aws_organizations_policy_attachment" "example-account_security" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.example-account_security.id
}

resource "aws_organizations_policy_attachment" "example-account_proxy_dev" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.example-account_proxy_dev.id
}

resource "aws_organizations_policy_attachment" "example-account_proxy_test" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.example-account_proxy_test.id
}

resource "aws_organizations_policy_attachment" "example-account_proxy_prod" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.example-account_proxy_prod.id
}

resource "aws_organizations_policy_attachment" "shared_services" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.example-account_shared_services.id
}

resource "aws_organizations_policy_attachment" "core_full_access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.core.id
}

resource "aws_organizations_policy_attachment" "product_full_access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.product.id
}

resource "aws_organizations_policy_attachment" "shared_full_access" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organizational_unit.shared.id
}

resource "aws_organizations_policy_attachment" "example-account_networking" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_account.example-account_networking.id
}
module "aws_auth" {
  source          = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//vault_aws_auth?ref=v1.0.0"
  create_aws_auth = true
}

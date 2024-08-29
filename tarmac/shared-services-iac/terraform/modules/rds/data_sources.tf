data "aws_secretsmanager_secret" "rds_password" {
  count = local.default
  name  = "phpipam_rds_password"
}

data "aws_secretsmanager_secret_version" "rds_password" {
  count     = local.default
  secret_id = data.aws_secretsmanager_secret.rds_password[count.index].id
}

resource "random_password" "adminPassword" {
  count = local.default

  length  = 20
  special = false

}

resource "random_password" "dbPassword" {
  count = local.default

  length  = 20
  special = false

}

resource "aws_secretsmanager_secret" "adminsecret" {
  count                   = local.default
  name                    = format("%s-%s-adminpassword", lower(var.app), var.env)
  recovery_window_in_days = 7
  tags = merge(
    var.tags,
    tomap(
      {
        "Name"           = format("%s-%s-adminpassword", lower(var.app), lower(var.env))
        "SourcecodeRepo" = "https://github.com/clinician-nexus/shared-services-iac"
      }
    )
  )

}

resource "aws_secretsmanager_secret_version" "secret_value" {
  count         = local.default
  secret_id     = aws_secretsmanager_secret.adminsecret[0].id
  secret_string = <<EOF
   {
    "password": "${random_password.adminPassword[0].result}"
   }
  EOF
}

resource "aws_secretsmanager_secret" "dbsecret" {
  count                   = local.default
  name                    = format("%s-%s-dbpassword", lower(var.app), var.env)
  recovery_window_in_days = 7
  tags = merge(
    var.tags,
    tomap(
      {
        "Name"           = format("%s-%s-dbpassword", lower(var.app), lower(var.env))
        "SourcecodeRepo" = "https://github.com/clinician-nexus/shared-services-iac"
      }
    )
  )

}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  count         = local.default
  secret_id     = aws_secretsmanager_secret.dbsecret[0].id
  secret_string = <<EOF
   {
    "password": "${random_password.dbPassword[0].result}"
   }
  EOF
}

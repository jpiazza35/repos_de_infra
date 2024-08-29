resource "random_password" "password" {
  count            = local.default
  length           = 28
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "rds_password" {
  count                          = local.default
  name                           = format("%s_rds_password", var.db_name)
  description                    = "Password for RDS DB"
  force_overwrite_replica_secret = false
  recovery_window_in_days        = 30
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  count     = local.default
  secret_id = aws_secretsmanager_secret.rds_password[count.index].id
  secret_string = jsonencode({
    username             = var.user_name
    password             = random_password.password[count.index].result
    engine               = var.engine
    host                 = aws_db_instance.rds[0].address
    port                 = var.engine == "mysql" || var.engine == "mariadb" ? "3306" : "5432"
    dbname               = var.db_name
    dbInstanceIdentifier = var.identifier
  })

}

resource "vault_generic_secret" "rds_password" {
  count = local.default
  path  = "devops/${var.db_name}/rds"

  data_json = jsonencode(
    {
      username             = var.user_name
      password             = random_password.password[count.index].result
      engine               = var.engine
      host                 = aws_db_instance.rds[0].address
      port                 = var.engine == "mysql" || var.engine == "mariadb" ? "3306" : "5432"
      dbname               = var.db_name
      dbInstanceIdentifier = var.identifier
  })

}

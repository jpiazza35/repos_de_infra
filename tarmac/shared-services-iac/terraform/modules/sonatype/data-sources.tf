# Sonatype

data "aws_secretsmanager_secret" "sonatype_secret" {
  name = "sonatype"
}

data "aws_secretsmanager_secret_version" "sonatype_secret_version" {
  secret_id = data.aws_secretsmanager_secret.sonatype_secret.id
}

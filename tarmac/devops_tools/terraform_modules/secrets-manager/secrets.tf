resource "aws_secretsmanager_secret" "my_secrets" {
  name                    = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-secrets"
  description             = "This secrets has all the necessary credentials for ${var.tags["Environment"]} ${var.tags["Application"]} services."
  recovery_window_in_days = var.recovery_window_in_days

  tags = var.tags
}

resource "aws_secretsmanager_secret_policy" "my_secrets" {
  secret_arn = aws_secretsmanager_secret.my_secrets.arn

  policy = data.template_file.secretsmanager_access.rendered
}
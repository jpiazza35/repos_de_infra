# Allows SecretsManager access via VPC endpoint only
data "template_file" "secretsmanager_access" {
  template = file("${path.module}/iam_policies/secretsmanager_access.json")
  vars = {
    aws_secretsmanager_secret = aws_secretsmanager_secret.my_secrets.arn
    secrets_vpc_endpoint      = var.secrets_vpc_endpoint_id
    organization_id           = var.organization_id
  }
}
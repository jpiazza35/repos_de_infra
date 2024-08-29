data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "backend_repository" {
  name = var.oidc_ecr_backend_name
}
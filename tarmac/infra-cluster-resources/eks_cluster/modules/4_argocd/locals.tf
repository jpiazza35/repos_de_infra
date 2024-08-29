locals {
  preview_applications = var.environment == "prod" ? fileset("${path.module}/applications/preview", "*.yaml") : []
}
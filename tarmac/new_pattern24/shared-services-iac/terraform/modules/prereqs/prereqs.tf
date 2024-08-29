module "prereqs" {
  source        = "./modules/prereqs"
  env           = var.env
  app           = var.app
  dynamodb_name = var.dynamodb_name
  bucket_name   = var.bucket_name
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = var.app
      Resource       = "Managed by Terraform"
      Description    = "S3 Backend Resources for Terraform"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

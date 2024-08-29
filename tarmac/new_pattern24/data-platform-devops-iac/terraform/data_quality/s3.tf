module "s3" {
  source   = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//s3?ref=1.0.160"
  for_each = var.s3_buckets

  bucket_properties = each.value

  tags = merge(
    var.tags,
    {
      Environment    = each.value.env
      App            = var.app
      Resource       = "Managed by Terraform"
      Description    = "Data Quality Service Related Configuration"
      Team           = "DevOps"
      SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    }
  )
}

resource "aws_s3_bucket_policy" "s3" {
  for_each = var.s3_buckets
  bucket   = module.s3[each.key].s3_bucket_id
  policy = templatefile("${path.module}/templates/s3_bucket_policy.json",
    {
      bucket_name     = module.s3[each.key].s3_bucket_id
      vpc_endpoint_id = data.aws_vpc_endpoint.s3.id
  })
}
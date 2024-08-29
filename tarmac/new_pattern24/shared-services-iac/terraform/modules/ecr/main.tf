resource "aws_ecr_repository" "ecr" {
  name                 = format("%s-ecr-repo", lower(var.app))
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    var.tags,
    {
      Name           = format("%s-ecr-repo", lower(var.app))
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )
}

## Set ECR policy only on is_mpt ECR repos (name with app-*)
resource "aws_ecr_repository_policy" "ecr" {
  count      = local.is_mpt
  repository = aws_ecr_repository.ecr.name
  policy     = data.aws_iam_policy_document.ecr.json
}

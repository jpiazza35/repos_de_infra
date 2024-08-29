#These two repositories are only an example on how to create the resource.
#For the actual project the number of repositories is much larger.

resource "aws_ecr_lifecycle_policy" "ecr_server" {
  repository = aws_ecr_repository.server.name
  policy     = data.template_file.ecr_lifecycle_policy.rendered
}

resource "aws_ecr_lifecycle_policy" "ecr_server_prod" {
  repository = aws_ecr_repository.server_prod.name
  policy     = data.template_file.ecr_lifecycle_policy.rendered
}
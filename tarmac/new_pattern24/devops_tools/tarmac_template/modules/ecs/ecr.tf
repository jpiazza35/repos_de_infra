resource "aws_ecr_repository" "etl_repository" {
  name                 = "default"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "etl_repository_lifecycle" {
  repository = aws_ecr_repository.etl_repository.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 5 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })
}

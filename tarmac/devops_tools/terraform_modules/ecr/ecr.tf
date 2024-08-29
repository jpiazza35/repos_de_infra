#These two repositories are only an example on how to create the resource.
#For the actual project the number of repositories is much larger.

resource "aws_ecr_repository" "server" {
  name = var.server_ecr_name

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_repository" "server_prod" {
  name                 = var.server_ecr_name_prod
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
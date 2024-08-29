resource "aws_ecr_repository" "ecr" {
  name                 = "${var.properties.environment}-${var.properties.product}-${var.properties.name}-ecr"
  image_tag_mutability = var.properties.ecr.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.properties.ecr.image_scanning.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
  repository = aws_ecr_repository.ecr.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = var.properties.ecr.lifecycle_policy.description
      action = {
        type = var.properties.ecr.lifecycle_policy.action_type
      }
      selection = {
        tagStatus   = var.properties.ecr.lifecycle_policy.selection_tag_status
        countType   = var.properties.ecr.lifecycle_policy.selection_count_type
        countNumber = var.properties.ecr.lifecycle_policy.selection_count_number
      }
    }]
  })
}

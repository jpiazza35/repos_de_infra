resource "aws_ecr_repository" "ecr-repo" {
  name = var.tags["projectname"]
}
resource "aws_ecr_lifecycle_policy" "lifecycle" {
  repository = aws_ecr_repository.ecr-repo.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 20 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 20
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
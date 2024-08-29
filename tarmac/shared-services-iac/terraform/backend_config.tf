
# this creates the role and policy for the terraform backend to use

resource "aws_iam_role" "terraform-backend-role" {
  #checkov:skip=CKV_AWS_61: "Skipping this because it is configured to just allow access to s3 bucket to AWS accounts managed by devops team"
  name = "terraform-backend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.backend_accounts_ids
        }
      }
    ]
  })
}


resource "aws_iam_policy" "terraform-backend-policy" {
  name = "terraform-backend-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::cn-terraform-state-s3", ## SS_Tools account
          "arn:aws:s3:::cn-terraform-state-s3/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = var.backend_dynamodb_table_arn ## SS_Tools account
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform-backend-policy" {
  policy_arn = aws_iam_policy.terraform-backend-policy.arn
  role       = aws_iam_role.terraform-backend-role.name
}

output "role_arn" {
  value       = aws_iam_role.terraform-backend-role.arn
  sensitive   = false
  description = "Role ARN for the terraform backend"
  depends_on  = [aws_iam_role_policy_attachment.terraform-backend-policy]
}





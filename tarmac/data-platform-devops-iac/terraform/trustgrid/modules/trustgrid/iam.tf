################################
###      IAM RESOURCES       ###
################################

resource "aws_iam_role" "ec2" {

  name = format("%s-%s-ec2-role", var.app, var.env)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": "InstanceRole"
    }
  ]
}
EOF

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation",
    aws_iam_policy.ec2.arn
  ]

  tags = merge(
    var.tags,
    tomap(
      {
        "Name" = format("%s-%s-ec2-role", var.app, var.env)
      }
    )
  )

}

resource "aws_iam_instance_profile" "ec2" {

  name = format("%s-ec2-instance-profile", var.env)
  role = aws_iam_role.ec2.name
}

resource "aws_iam_policy" "ec2" {

  name        = format("%s-%s-ec2-policy", var.app, var.env)
  description = "EC2 Instance Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "ec2:*"
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:List*",
          "kms:Get*",
          "kms:ReEncrypt*",
          "kms:Describe*",
          "kms:Decrypt*",
          "kms:Encrypt*",
          "kms:GenerateDataKey",
          "kms:CreateGrant",
          "kms:ImportKeyMaterial",
          "secretsmanager:GetSecretValue",
        ],
        Resource = "*"
      }
    ]
  })
  tags = merge(
    var.tags,
    tomap(
      {
        "Name" = format("%s-%s-ec2-policy", var.app, var.env)
      }
    )
  )
}

resource "aws_iam_role_policy_attachment" "ec2_vault" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2.arn
}

resource "aws_iam_service_linked_role" "asg" {
  aws_service_name = "autoscaling.amazonaws.com"
}

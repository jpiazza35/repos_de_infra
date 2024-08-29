################################
###      IAM RESOURCES       ###
################################

resource "aws_iam_role" "ec2" {
  count = local.default
  name  = format("%s-%s-ec2-role", var.app, var.env)

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
    aws_iam_policy.ec2[count.index].arn
  ]

  tags = merge(
    var.tags,
    tomap(
      {
        "Name"           = format("%s-%s-ec2-role", var.app, var.env)
        "SourcecodeRepo" = "https://github.com/clinician-nexus/shared-services-iac"
      }
    )
  )

}

resource "aws_iam_instance_profile" "ec2" {
  count = local.default
  name  = format("%s-ec2-instance-profile", var.env)
  role  = aws_iam_role.ec2[count.index].name
}

resource "aws_iam_policy" "ec2" {
  count       = local.default
  name        = format("%s-%s-ec2-policy", var.app, var.env)
  description = "EC2 Instance Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = [
          "arn:aws:iam::*:role/vault_aws_auth"
        ]
      },
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
          "s3:Get*",
          "s3:PutObject",
          "s3:List*"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "rds:*"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "acm:AddTagsToCertificate",
          "acm:DescribeCertificate",
          "acm:GetCertificate",
          "acm:ListCertificates",
          "acm:ListTagsForCertificate",
          "kms:List*",
          "kms:Get*",
          "kms:ReEncrypt*",
          "kms:Describe*",
          "kms:Decrypt*",
          "kms:Encrypt*",
          "kms:GenerateDataKey",
          "kms:CreateGrant",
          "kms:ImportKeyMaterial",
          "iam:GetServerCertificate",
          "iam:ListServerCertificates",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:SetLoadBalancerListenerSSLCertificate",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups",
          "ec2:CreateTags",
          "ec2:Describe*",
          "dynamodb:DescribeLimits",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListTagsOfResource",
          "dynamodb:DescribeReservedCapacityOfferings",
          "dynamodb:DescribeReservedCapacity",
          "dynamodb:ListTables",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:CreateTable",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:GetRecords",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:Scan",
          "dynamodb:DescribeTable",
          "ssm:*",
          "secretsmanager:GetSecretValue",
          "iam:GetRole"
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
  count      = local.default
  role       = aws_iam_role.ec2[count.index].name
  policy_arn = aws_iam_policy.ec2[count.index].arn
}

# Task logging privileges
data "aws_iam_policy_document" "ecr" {

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::946884638317:root",
        "arn:aws:iam::071766652168:root",
        "arn:aws:iam::063890802877:root",
        "arn:aws:iam::964608896914:root",
        "arn:aws:iam::472485266432:root",
        "arn:aws:iam::679687097709:root",
        "arn:aws:iam::993562814415:root"
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]
  }
}
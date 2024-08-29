data "aws_iam_policy" "ecr_read_only_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "s3_full_acess_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "template_file" "allow_cross_account_access_shared_account" {
  template = file("${path.module}/iam_policies/allow_cross_account_access_shared_account.json")
}
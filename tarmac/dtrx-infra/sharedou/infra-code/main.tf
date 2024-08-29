module "codecommit" {
  source = "../../modules/codecommit"

  repo_name = "aws-terraform"

  tags = merge(
    var.tags,
    {
      "AWSService" = "CodeCommit"
    },
  )
}
resource "aws_codecommit_repository" "terraform" {
  repository_name = var.repo_name
  description     = "The CodeCommit repository that contains the terraform code for all example-account AWS accounts."

  tags = var.tags
}
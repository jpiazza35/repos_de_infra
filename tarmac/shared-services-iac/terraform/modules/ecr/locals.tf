locals {
  is_mpt = length(regexall("app-*", aws_ecr_repository.ecr.name)) ## fetch only app-* named ECR repos
}
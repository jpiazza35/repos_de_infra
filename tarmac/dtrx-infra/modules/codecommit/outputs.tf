output "codecommit_repo_http_url" {
  value = aws_codecommit_repository.terraform.clone_url_http
}
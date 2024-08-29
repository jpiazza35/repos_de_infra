resource "aws_codestarnotifications_notification_rule" "terraform_repo_notifications" {
  detail_type = "BASIC"
  event_type_ids = ["codecommit-repository-comments-on-pull-requests",
    "codecommit-repository-approvals-status-changed",
    "codecommit-repository-pull-request-created",
    "codecommit-repository-pull-request-status-changed",
  "codecommit-repository-pull-request-merged"]

  name     = "${var.tags["Environment"]}-${var.tags["Application"]}-notifications"
  resource = aws_codecommit_repository.terraform.arn

  target {
    address = var.sns_codecommit
  }
}
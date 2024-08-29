resource "aws_db_event_subscription" "user_creation" {
  name             = "rds-lambda"
  sns_topic        = var.alerts_sns_topic_arn
  source_type      = "db-instance"
  source_ids       = [aws_db_instance.postgresql.id]
  event_categories = ["creation"]

  tags = var.tags
}

resource "aws_db_event_subscription" "backup" {
  name             = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-backup"
  sns_topic        = var.alerts_sns_topic_arn
  source_type      = "db-instance"
  event_categories = ["backup"]

  tags = var.tags
}

resource "aws_db_event_subscription" "snapshot" {
  name             = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-snapshot"
  sns_topic        = var.alerts_sns_topic_arn
  source_type      = "db-snapshot"
  event_categories = ["creation"]

  tags = var.tags
}
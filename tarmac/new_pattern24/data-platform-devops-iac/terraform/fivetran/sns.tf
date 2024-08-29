# resource "aws_sns_topic" "this" {
#   name = "${var.app}-rds-events"
#   tags = var.tags
# }

# # Invoke lambda function on SNS event
# #
# resource "aws_sns_topic_subscription" "this" {
#   topic_arn = aws_sns_topic.this.arn
#   protocol  = "lambda"
#   endpoint  = module.lambda.lambda_arn
# }

# resource "aws_db_event_subscription" "this" {
#   name      = "${var.name}-rds-event-sub"
#   sns_topic = aws_sns_topic.this.arn

#   source_type = "db-instance"
#   source_ids  = var.target_db_instance_ids
#   event_categories = [
#     "availability",
#     "deletion",
#     "failover",
#     "failure",
#     "maintenance",
#     "notification",
#     "read replica",
#     "recovery",
#     "restoration",
#   ]
#   tags       = var.tags
# }

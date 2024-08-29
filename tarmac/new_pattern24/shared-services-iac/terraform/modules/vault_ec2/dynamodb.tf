resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = format("%s-%s", var.env, var.app)
  billing_mode   = "PROVISIONED"
  hash_key       = "Path"
  range_key      = "Key"
  read_capacity  = 100
  write_capacity = 60

  attribute {
    name = "Path"
    type = "S"
  }
  attribute {
    name = "Key"
    type = "S"
  }

  # lifecycle {
  #   ignore_changes = [read_capacity, write_capacity]
  # }

  tags = {
    Name           = format("%s-%s", var.env, var.app)
    Environment    = var.env
    backup         = "daily"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}

# resource "aws_appautoscaling_target" "basic-dynamodb-table-read-target" {
#   resource_id        = "table/${aws_dynamodb_table.basic-dynamodb-table.name}"
#   scalable_dimension = "dynamodb:table:ReadCapacityUnits"
#   service_namespace  = "dynamodb"
#   min_capacity       = 1
#   max_capacity       = 120

# }

# resource "aws_appautoscaling_policy" "basic-dynamodb-table-read-policy" {
#   name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.basic-dynamodb-table-read-target.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   service_namespace  = aws_appautoscaling_target.basic-dynamodb-table-read-target.service_namespace
#   scalable_dimension = aws_appautoscaling_target.basic-dynamodb-table-read-target.scalable_dimension
#   resource_id        = aws_appautoscaling_target.basic-dynamodb-table-read-target.resource_id

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBReadCapacityUtilization"
#     }

#     target_value = 70.0
#   }

# }

# resource "aws_appautoscaling_target" "basic-dynamodb-table-write-target" {
#   resource_id        = "table/${aws_dynamodb_table.basic-dynamodb-table.name}"
#   scalable_dimension = "dynamodb:table:WriteCapacityUnits"
#   service_namespace  = "dynamodb"
#   min_capacity       = 1
#   max_capacity       = 100
# }

# resource "aws_appautoscaling_policy" "basic-dynamodb-table-write-policy" {
#   name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.basic-dynamodb-table-write-target.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   service_namespace  = aws_appautoscaling_target.basic-dynamodb-table-write-target.service_namespace
#   scalable_dimension = aws_appautoscaling_target.basic-dynamodb-table-write-target.scalable_dimension
#   resource_id        = aws_appautoscaling_target.basic-dynamodb-table-write-target.resource_id

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "DynamoDBWriteCapacityUtilization"
#     }

#     target_value = 70.0
#   }
# }

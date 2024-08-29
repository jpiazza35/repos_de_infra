resource "aws_db_instance" "postgresql" {
  identifier = "${var.tags["Environment"]}-${var.tags["Product"]}-${var.db_engine}-db"
  #final_snapshot_identifier = "${var.tags["Environment"]}-${var.name_identifier}-${var.db_engine}-db-v001"
  allocated_storage                     = var.db_allocated_storage
  max_allocated_storage                 = var.db_max_allocated_storage
  storage_type                          = var.db_storage_type
  storage_encrypted                     = var.db_storage_encrypted
  engine                                = var.db_engine
  engine_version                        = var.db_engine_version
  instance_class                        = var.db_instance_class
  deletion_protection                   = var.db_deletion_protection
  skip_final_snapshot                   = var.db_skip_final_snapshot
  apply_immediately                     = var.db_apply_immediately
  auto_minor_version_upgrade            = var.db_auto_minor_version_upgrade
  performance_insights_enabled          = var.db_performance_insights_enabled
  performance_insights_kms_key_id       = var.db_performance_insights_enabled ? var.db_performance_insights_kms_key_id : ""
  performance_insights_retention_period = var.db_performance_insights_enabled ? var.db_performance_insights_retention_period : 0
  monitoring_interval                   = var.db_monitoring_interval
  monitoring_role_arn                   = var.db_monitoring_interval == 0 ? "" : aws_iam_role.db_monitoring.arn
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports

  username                            = var.db_username
  password                            = var.db_password
  name                                = var.db_database
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  db_subnet_group_name                = aws_db_subnet_group.postgresql.name
  parameter_group_name                = aws_db_parameter_group.postgresql.name
  multi_az                            = var.db_multi_az
  backup_retention_period             = var.db_backup_retention_period_days
  vpc_security_group_ids              = [aws_security_group.postgresql.id]

  tags = merge(
    {
      Name = "${var.tags["Environment"]}-${var.tags["Product"]}-postgresql-db"
    },
    var.tags,
  )

  depends_on = [
    aws_lambda_function.user_creation
  ]
}

resource "aws_db_subnet_group" "postgresql" {
  name       = "${var.tags["Environment"]}-${var.tags["Product"]}-postgresql-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = var.tags
}

# This IAM role allows RDS to send enhanced monitoring data to Cloudwatch
resource "aws_iam_role" "db_monitoring" {
  name               = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-enhanced-monitoring-role"
  assume_role_policy = var.db_enhanced_assume_policy
  description        = "This IAM role allows RDS to send enhanced monitoring data to Cloudwatch."

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "db_monitoring" {
  role       = aws_iam_role.db_monitoring.name
  policy_arn = var.db_enhanced_monitoring_policy_arn
}

resource "aws_db_parameter_group" "postgresql" {
  name   = "${var.tags["Environment"]}-${var.tags["Product"]}-${var.db_engine}-parameter-group"
  family = var.db_parameter_group_family

  parameter {
    name  = "log_statement"
    value = var.log_statement_value
  }

  parameter {
    name  = "log_min_duration_statement"
    value = var.log_min_duration_statement_value
  }
}
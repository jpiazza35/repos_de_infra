resource "random_id" "snapshot_identifier" {
  count = local.default
  keepers = {
    id = var.name
  }
  byte_length = 4
}

############### DB subnet group ###########
resource "aws_db_subnet_group" "rds_subnet" {
  count       = local.default
  name        = var.subnet_name
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids
}

resource "aws_db_instance" "rds" {
  count = local.default

  allocated_storage               = var.allocated_storage
  max_allocated_storage           = var.max_allocated_storage
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  identifier                      = var.identifier
  db_name                         = var.db_name
  username                        = var.user_name != "" ? var.user_name : "admin"
  password                        = random_password.password[count.index].result
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet[count.index].name
  multi_az                        = var.multi_az
  vpc_security_group_ids          = var.rds_security_group
  storage_type                    = var.storage_type
  iops                            = var.storage_type == "io1" ? var.iops : null
  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  deletion_protection             = var.deletion_protection
  delete_automated_backups        = var.delete_automated_backups
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  skip_final_snapshot             = var.skip_final_snapshot
  backup_retention_period         = var.backup_retention_period
  storage_encrypted               = true
  copy_tags_to_snapshot           = true
  # Enhanced monitoring
  monitoring_interval = var.enhanced_monitoring_role_enabled == true ? var.monitoring_interval : 0

  monitoring_role_arn             = var.enhanced_monitoring_role_enabled == true ? aws_iam_role.rds_enhanced_monitoring[0].arn : ""
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_enabled == true ? var.performance_insights_kms_key_id : ""
  final_snapshot_identifier       = "${replace(var.db_name, "_", "-")}-final-${element(concat(random_id.snapshot_identifier.*.hex, [""]), 0)}"
  snapshot_identifier             = var.restore_rds_from_snapshot == true ? var.snapshot_identifier : null

  tags = merge(
    var.tags,
    {
      Name = "phpipam-mariadb"
    }
  )

  lifecycle {
    ignore_changes = [
    ]
  }
}

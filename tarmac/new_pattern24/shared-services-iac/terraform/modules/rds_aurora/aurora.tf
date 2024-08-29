resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier      = "${var.tags["env"]}-${var.tags["product"]}-${var.tags["service"]}-cluster"
  engine                  = var.cluster.cluster_engine
  engine_mode             = var.cluster.cluster_engine_mode
  engine_version          = var.cluster.cluster_engine_version
  apply_immediately       = var.cluster.cluster_apply_immediately
  database_name           = var.cluster.cluster_database_name
  master_username         = var.cluster.cluster_master_username
  master_password         = local.password
  backup_retention_period = var.cluster.cluster_backup_retention_period
  storage_encrypted       = true
  skip_final_snapshot     = var.cluster.skip_final_snapshot
  vpc_security_group_ids  = [aws_security_group.aurora_segurity_group.id]
  kms_key_id              = aws_kms_key.db_cluster.arn
  db_subnet_group_name    = aws_db_subnet_group.db_cluster_subnet_group.name

  serverlessv2_scaling_configuration {
    max_capacity = var.cluster.serverless_scaling_configuration.max_capacity
    min_capacity = var.cluster.serverless_scaling_configuration.min_capacity
  }
}

resource "aws_db_subnet_group" "db_cluster_subnet_group" {
  name        = "${var.tags["env"]}-${var.tags["product"]}-${var.tags["service"]}-${var.cluster_subnet_group_name}"
  description = "RDS DB subnet group resource for Aurora Cluster"
  subnet_ids  = data.aws_subnets.private.ids
  tags        = var.tags
}

resource "random_password" "master_password" {
  for_each         = toset([var.trigger_rotation])
  length           = var.cluster_root_password_length
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_rds_cluster_instance" "db_cluster_instance" {
  identifier                            = "${var.tags["env"]}-${var.tags["product"]}-${var.tags["service"]}-instance"
  instance_class                        = var.instance.instance_class
  cluster_identifier                    = aws_rds_cluster.db_cluster.id
  engine                                = aws_rds_cluster.db_cluster.engine
  engine_version                        = aws_rds_cluster.db_cluster.engine_version
  db_subnet_group_name                  = aws_db_subnet_group.db_cluster_subnet_group.name
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = aws_kms_key.db_cluster_instance_insights.arn
  performance_insights_retention_period = 31
}

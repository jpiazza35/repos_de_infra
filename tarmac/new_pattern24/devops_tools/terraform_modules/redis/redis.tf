resource "aws_elasticache_subnet_group" "redis_sub_group" {
  name       = "${var.tags["Environment"]}-${var.tags["Product"]}-redis-subnet-group"
  subnet_ids = var.private_subnets

  tags = var.tags
}

resource "aws_elasticache_replication_group" "card_ranges" {
  automatic_failover_enabled    = var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  replication_group_id          = "${var.tags["Environment"]}-${var.tags["Product"]}-card-ranges-cluster"
  replication_group_description = "Redis cluster for Card Ranges"
  node_type                     = var.redis_instance_type
  engine_version                = var.redis_engine
  port                          = 6379
  parameter_group_name          = var.parameter_group_name
  snapshot_retention_limit      = 1
  snapshot_window               = "03:00-05:00"
  subnet_group_name             = aws_elasticache_subnet_group.redis_sub_group.name
  security_group_ids            = [aws_security_group.sg_redis.id]
  apply_immediately             = var.apply_immediately

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 1
  }

  tags = var.tags

  depends_on = [
    aws_security_group.sg_redis
  ]
}
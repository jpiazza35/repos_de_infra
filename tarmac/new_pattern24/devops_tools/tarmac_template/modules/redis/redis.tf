resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id         = "default-redis-${var.environment}-cluster"
  engine             = "redis"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  port               = 6379
  apply_immediately  = true
  security_group_ids = [var.redis_security_group]
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
  /*log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis_service_log_group.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }*/
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = var.redis_subnet_group_name
  subnet_ids = var.redis_subnet_ids
}

resource "aws_cloudwatch_log_group" "redis_service_log_group" {
  name              = "/redis/default-redis-dev"
  retention_in_days = 7

  tags = {
    Name = "default-redis-log-dev"
  }
}

resource "aws_cloudwatch_log_stream" "redis_service_log_stream" {
  name           = "default-redis-dev"
  log_group_name = aws_cloudwatch_log_group.redis_service_log_group.name
}

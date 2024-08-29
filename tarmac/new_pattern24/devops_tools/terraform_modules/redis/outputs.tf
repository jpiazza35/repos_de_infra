output "elasticache_redis_cluster_name" {
  description = "The name of the Elasticache Redis cluster."
  value       = aws_elasticache_replication_group.card_ranges.replication_group_id
}

output "elasticache_redis_cluster_endpoint" {
  description = "The configuration endpoint of the Elasticache Redis cluster."
  value       = aws_elasticache_replication_group.card_ranges.configuration_endpoint_address
}

output "elasticache_redis_cluster_port" {
  description = "The port of the Elasticache Redis cluster."
  value       = aws_elasticache_replication_group.card_ranges.port
}

output "elasticache_redis_sg_id" {
  description = "The Elasticache Redis security group ID."
  value       = aws_security_group.sg_redis.id
}
output "db_cluster_identifier" {
  description = "DB Cluster Identifier"
  value       = aws_rds_cluster.db_cluster.cluster_identifier
  sensitive   = true
}

output "db_cluster_port" {
  description = "DB Cluster port"
  value       = aws_rds_cluster.db_cluster.port
  sensitive   = true
}

output "db_cluster_username" {
  description = "DB Cluster username"
  value       = aws_rds_cluster.db_cluster.master_username
  sensitive   = true
}
output "db_cluster_port" {
  description = "DB Cluster port"
  value       = aws_rds_cluster.db_cluster.port
  sensitive   = true
}
#
output "db_cluster_username" {
  description = "DB Cluster master username"
  value       = aws_rds_cluster.db_cluster.master_username
  sensitive   = true
}

output "db_cluster_password" {
  description = "DB Cluster master password"
  value       = aws_rds_cluster.db_cluster.master_password
  sensitive   = true
}

output "db_cluster_endpoint" {
  description = "DB Cluster write endpoint"
  value       = aws_rds_cluster.db_cluster.endpoint
  sensitive   = true
}

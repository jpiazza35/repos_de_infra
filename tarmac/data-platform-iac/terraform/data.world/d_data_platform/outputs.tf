output "input" {
  value     = local.source_input
  sensitive = true
}

output "ecs_cluster" {
  value = local.ecs_cluster_name
}

output "sec_gr_id" {
  value = local.security_group_id
}

output "container" {
  value = local.container_name
}

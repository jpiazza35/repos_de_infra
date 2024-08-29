output "aws_security_group_id" {
  value = aws_security_group.ecs_security_group.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs.name
}

output "ecs_container_id" {
  value = {
    for k, v in aws_ecs_task_definition.ecs : k => v.family
  }
}

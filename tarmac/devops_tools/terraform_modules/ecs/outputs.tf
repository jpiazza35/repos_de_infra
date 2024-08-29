output "ecs_target_group_arn" {
  value = aws_lb_target_group.i_ecs.*.arn
}

output "ecs_target_group_name" {
  value = aws_lb_target_group.i_ecs.*.name
}

output "ecs_target_group_port" {
  value = aws_lb_target_group.i_ecs.*.port
}

output "ecs_service_id" {
  value       = aws_ecs_service.ecs.*.id
  description = "The Amazon Resource Name (ARN) that identifies the service."
}

output "ecs_service_name" {
  value       = aws_ecs_service.ecs.*.id
  description = "The name of the service."
}

output "ecs_service_desired_count" {
  value       = aws_ecs_service.ecs.*.id
  description = "The number of instances of the task definition."
}

output "ecs_security_group_id" {
  value       = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
  description = "The ID of the ECS Service security group."
}

output "ecs_security_group_arn" {
  value       = element(concat(aws_security_group.ecs.*.arn, tolist([""])), 0)
  description = "The ARN of the ECS Service security group."
}

output "ecs_security_group_name" {
  value       = element(concat(aws_security_group.ecs.*.arn, tolist([""])), 0)
  description = "The name of the ECS Service security group."
}

output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.ecs.*.arn
  description = "Full ARN of the Task Definition (including both family and revision)."
}

output "ecs_task_definition_family" {
  value       = aws_ecs_task_definition.ecs.*.family
  description = "The family of the Task Definition."
}

output "ecs_efs_task_definition_arn" {
  value       = aws_ecs_task_definition.ecs_efs.*.arn
  description = "Full ARN of the Task Definition (including both family and revision)."
}

output "ecs_efs_task_definition_family" {
  value       = aws_ecs_task_definition.ecs_efs.*.family
  description = "The family of the Task Definition."
}

output "ecs_internal_lb_target_group" {
  value = aws_lb_target_group.i_ecs.*.arn
}

output "ecs_cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.ecs.arn
}

output "ecs_cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}

output "ecs_private_r53_record_name" {
  value = element(concat(aws_route53_record.private.*.name, tolist([""])), 0)
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs.*.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs.*.name
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs.arn
}

output "efs_volume_name" {
  value = aws_efs_file_system.ecs_efs.*.creation_token
}

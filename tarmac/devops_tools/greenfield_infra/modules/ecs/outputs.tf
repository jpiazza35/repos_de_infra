output "target_group_arn" {
  value = join("", aws_lb_target_group.ecs-target-group.*.arn)
}

output "alb_target_group_name" {
  value = join("", aws_lb_target_group.ecs-target-group.*.name)
}

output "ecs_service_id" {
  value       = join("", aws_ecs_service.ecs-service.*.id)
  description = "The Amazon Resource Name (ARN) that identifies the service."
}

output "ecs_service_name" {
  value       = join("", aws_ecs_service.ecs-service.*.name)
  description = "The name of the service."
}

output "ecs_service_desired_count" {
  value       = join("", aws_ecs_service.ecs-service.*.desired_count)
  description = "The number of instances of the task definition."
}

output "security_group_id" {
  value       = join("", aws_security_group.ecs-service-sg.*.id)
  description = "The ID of the ECS Service security group."
}

output "security_group_arn" {
  value       = join("", aws_security_group.ecs-service-sg.*.arn)
  description = "The ARN of the ECS Service security group."
}

output "security_group_vpc_id" {
  value       = join("", aws_security_group.ecs-service-sg.*.vpc_id)
  description = "The VPC ID of the ECS Service security group."
}

output "security_group_owner_id" {
  value       = join("", aws_security_group.ecs-service-sg.*.owner_id)
  description = "The owner ID of the ECS Service security group."
}

output "security_group_name" {
  value       = join("", aws_security_group.ecs-service-sg.*.name)
  description = "The name of the ECS Service security group."
}

output "security_group_description" {
  value       = join("", aws_security_group.ecs-service-sg.*.description)
  description = "The description of the ECS Service security group."
}

output "security_group_ingress" {
  value       = aws_security_group.ecs-service-sg.*.ingress
  description = "The ingress rules of the ECS Service security group."
}

output "security_group_egress" {
  value       = aws_security_group.ecs-service-sg.*.egress
  description = "The egress rules of the ECS Service security group."
}

output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.ecs-task-def.*.arn
  description = "Full ARN of the Task Definition (including both family and revision)."
}

output "ecs_task_definition_family" {
  value       = aws_ecs_task_definition.ecs-task-def.*.family
  description = "The family of the Task Definition."
}

output "ecs_task_definition_revision" {
  value       = aws_ecs_task_definition.ecs-task-def.*.revision
  description = "The revision of the task in a particular family."
}

output "lb_target_group" {
  value = aws_lb_target_group.ecs-target-group.*.arn
}

output "internal_lb_target_group" {
  value = aws_lb_target_group.i-ecs-target-group.*.arn
}

output "public_r53" {
  value = aws_route53_record.ecs-public.name
}

output "private_r53" {
  value = aws_route53_record.ecs-private.name
}
output "phpipam_service_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the ECS service."
  value       = aws_ecs_service.phpipam[0].id
}

output "target_group_arn" {
  description = "The ARN of the Target Group used by Load Balancer."
  value       = [for tg_arn in aws_lb_target_group.task : tg_arn.arn]
}

output "target_group_name" {
  description = "The Name of the Target Group used by Load Balancer."
  value       = [for tg_name in aws_lb_target_group.task : tg_name.name]
}

output "task_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the ECS service role."
  value       = aws_iam_role.task[0].arn
}

output "task_role_name" {
  description = "The name of the Fargate task service role."
  value       = aws_iam_role.task[0].name
}

output "service_sg_id" {
  description = "The Amazon Resource Name (ARN) that identifies the service security group."
  value       = aws_security_group.ecs_service[0].id
}

output "phpipam_service_name" {
  description = "The name of the service."
  value       = aws_ecs_service.phpipam[0].name
}

output "log_group_name" {
  description = "The name of the Cloudwatch log group for the task."
  value       = aws_cloudwatch_log_group.main[0].name
}

output "execution_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the ECS execution role."
  value       = aws_iam_role.execution[0].arn
}

output "execution_role_name" {
  description = "The name of the ECS execution role."
  value       = aws_iam_role.execution[0].name
}

output "task_definition_arn" {
  description = "The Amazon Resource Name (ARN) of the task definition created"
  value       = aws_ecs_task_definition.task[0].arn
}

output "task_definition_name" {
  description = "The name of the task definition created"
  value       = aws_ecs_task_definition.task[0].arn
}

output "ecs_cluster" {
  description = "ECS Cluster"
  value       = aws_ecs_cluster.cluster[0].id
}

output "security_group_id" {
  description = "ECS Task SG"
  value       = aws_security_group.ecs_service[0].id
}

output "lb_security_group_id" {
  description = "ECS LB Security Group ID"
  value       = aws_security_group.load_balancer_security_group[0].id
}

output "alb_arn" {
  value = aws_alb.load_balancer[0].arn
}

output "lb_dns_name" {
  value = aws_alb.load_balancer[0].dns_name
}

output "lb_dns_zone" {
  value = aws_alb.load_balancer[0].zone_id
}

### Sonatype Artifactory

output "sonatype_alb_arn" {
  value = aws_alb.load_balancer_sonatype.arn
}

output "sonatype_lb_dns_name" {
  value = aws_alb.load_balancer_sonatype.dns_name
}

output "sonatype_lb_dns_zone" {
  value = aws_alb.load_balancer_sonatype.zone_id
}

### INCIDENT BOT

output "incident_bot_alb_arn" {
  value = aws_alb.load_balancer[0].arn
}

output "incident_bot_lb_dns_name" {
  value = aws_alb.load_balancer[0].dns_name
}

output "incident_bot_lb_dns_zone" {
  value = aws_alb.load_balancer[0].zone_id
}

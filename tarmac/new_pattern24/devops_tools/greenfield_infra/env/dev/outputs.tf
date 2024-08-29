output "ecs_service_id" {
  value = module.fargate.ecs_service_id
}

output "ecs_service_name" {
  value = module.fargate.ecs_service_name
}

output "ecs_service_desired_count" {
  value = module.fargate.ecs_service_desired_count
}

output "security_group_id" {
  value = module.fargate.security_group_id
}

output "security_group_arn" {
  value = module.fargate.security_group_arn
}

output "security_group_vpc_id" {
  value = module.fargate.security_group_vpc_id
}

output "security_group_owner_id" {
  value = module.fargate.security_group_owner_id
}

output "security_group_name" {
  value = module.fargate.security_group_name
}

output "security_group_description" {
  value = module.fargate.security_group_description
}

output "security_group_ingress" {
  value = module.fargate.security_group_ingress
}

output "security_group_egress" {
  value = module.fargate.security_group_egress
}
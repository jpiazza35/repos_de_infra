output "truststore_s3_bucket_name" {
  description = "The S3 bucket name that holds the API Gateway MTLS truststore.pem file."
  value       = aws_s3_bucket.api_gw_truststore.*.bucket
}

output "server_api_gw_name" {
  description = "The name of the 3ds-server API Gateway."
  value       = aws_api_gateway_rest_api.api_gw.name
}

output "server_api_gw_id" {
  description = "The ID of the 3ds-server API Gateway."
  value       = aws_api_gateway_rest_api.api_gw.id
}

output "i_alb_sg_id" {
  description = "The internal ALB security group ID."
  value       = aws_security_group.sg_i_alb.*.id
}

output "i_alb_sg_name" {
  description = "The internal ALB security group name."
  value       = aws_security_group.sg_i_alb.*.name
}

output "i_alb_sg_arn" {
  description = "The internal ALB security group ARN."
  value       = aws_security_group.sg_i_alb.*.arn
}

output "i_alb_dns_name" {
  description = "The internal ALB DNS name."
  value       = aws_lb.i_alb.*.dns_name
}

output "i_alb_zone_id" {
  description = "The internal ALB DNS zone ID."
  value       = aws_lb.i_alb.*.zone_id
}

output "i_nlb_dns_name" {
  description = "The internal NLB DNS name."
  value       = aws_lb.i_nlb.*.dns_name
}

output "i_nlb_zone_id" {
  description = "The internal NLB  DNS zone ID."
  value       = aws_lb.i_nlb.*.zone_id
}

output "api_gw_vpc_link_id" {
  value = aws_api_gateway_vpc_link.api_gw.*.id
}

output "i_alb_listener_arn" {
  value = aws_lb_listener.i_alb_443.*.arn
}

output "i_alb_listener_port" {
  value = aws_lb_listener.i_alb_443.*.port
}

output "clients_dns_record_name" {
  value = aws_route53_record.api_gw.*.name
}

output "api_gw_stage_arn" {
  value = aws_api_gateway_stage.stage.arn
}

output "alb_logs_s3_bucket_name" {
  description = "The S3 bucket name that stores the ALB logs."
  value       = aws_s3_bucket.alb_logs.*.bucket
}

output "api_gw_2nd_level_resource_ids" {
  description = "The IDs of the 2nd level API Gateway endpoints."
  value       = aws_api_gateway_resource.api_gw_2nd_level.*.id
}
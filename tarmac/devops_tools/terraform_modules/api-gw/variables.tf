variable "region" {
  type        = string
  description = "The AWS region to launch resources in."
}

variable "create_lb_resources" {
  type        = bool
  default     = false
  description = "Whether to create API GW Load Balancer resources. - true in admin module"
}

variable "create_2nd_level_endpoints" {
  type        = bool
  description = "Whether to create endpoints after the / endpoint in API GW."
}

variable "create_root_proxy_endpoint" {
  type        = bool
  description = "Whether to create the proxy resource after the / endpoint in API GW."
}

variable "create_alb_to_jump_host_sg_rule" {
  type        = bool
  description = "Whether to access ALB from the PP Jump Host"
  default     = false
}

variable "has_root_endpoint" {
  type        = bool
  description = "Whether the API GW has a root endpoints or not."
}

variable "has_internal_endpoints" {
  type        = bool
  description = "Whether the API GW has a internal endpoints or not."
}

variable "uses_get_method" {
  type        = bool
  description = "Whether the corresponding API GW has GET as a method."
}

variable "uses_put_method" {
  type        = bool
  description = "Whether the corresponding API GW has PUT as a method."
}

variable "uses_post_method" {
  type        = bool
  description = "Whether the corresponding API GW has POST as a method."
}

variable "uses_delete_method" {
  type        = bool
  description = "Whether the corresponding API GW has DELETE as a method."
}

variable "uses_any_method" {
  type        = bool
  description = "Whether the corresponding API GW has ANY as a method."
}

variable "uses_head_method" {
  type        = bool
  description = "Whether the corresponding API GW has HEAD as a method."
}

variable "uses_options_method" {
  type        = bool
  description = "Whether the corresponding API GW has OPTIONS as a method."
}

variable "uses_patch_method" {
  type        = bool
  description = "Whether the corresponding API GW has PATCH as a method."
}

variable "create_2nd_level_methods" {
  type        = bool
  description = "Whether to create methods and integrations directly on the 2nd level API GW endpoints."
}

variable "mtls" {
  type        = bool
  description = "Whether to the API GW resources needs mTLS or not."
}

variable "create_truststore" {
  type        = bool
  description = "Whether to create the truststore S3 bucket."
}

variable "create_api_gw_iam" {
  type        = bool
  description = "Whether to create the API GW IAM role in settings."
}

variable "create_ds_dns_resources" {
  type        = bool
  default     = false
  description = "Whether to create the DNS resources (zones, certs, records) per DS."
}

variable "create_internal_proxy_endpoints" {
  type        = bool
  description = "Whether to create proxy resource for the internal api gw endpoints."
}

variable "add_server_lb_certificate" {
  type        = bool
  description = "Whether to add the additional ACM 3ds-server certificate to the ALB 443 listener."
}

variable "alb_access_logs_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable logs for the ALB."
}

variable "nlb_access_logs_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable logs for the NLB."
}

variable "no_mtls_proxy_api_gw_request_parameters" {
  type        = map(any)
  description = "The no mtls API GW request parameters for the proxy path integration."
}

variable "mtls_proxy_api_gw_request_parameters" {
  type        = map(any)
  description = "The mlts API GW request parameters for the proxy path integration. This is where the org ID header is set."
}

variable "mtls_api_gw_request_parameters" {
  type        = map(any)
  description = "The API GW request parameters for the 3ds-server integrations. This is where the org ID header is set."
}

variable "no_mtls_api_gw_request_parameters" {
  type        = map(any)
  description = "The API GW request parameters for the admin integrations. This is where only the X-Forwarded-Host header is set."
}

variable "i_alb_listener_arn" {
  type        = string
  description = "The internal ALB listener ARN - used in 3ds-server."
}

variable "jump_host_cidr_block" {
  type        = string
  description = "The Jump Hosts CIDR IP range."
}

variable "proxy_catch_all" {
  type        = string
  description = "The proxy 'catch all' resource under the root (/) endpoint."
}

variable "internal_api_gw_endpoints" {
  type        = list(string)
  description = "The API GW endpoints that need to be internal (accessed via IP whitelisting)."
}

variable "internal_endpoints_methods" {
  type        = list(string)
  description = "The methods on the internal endpoints."
}

variable "api_gw_whitelisted_ip_range" {
  type        = list(any)
  description = "The IP addresses/ranges (comma separated string) that are allowed to access the certain API gateway(s) endpoints."
}

variable "api_gw_root_endpoint_methods" {
  type        = list(string)
  description = "The methods used in the API Gateway root (/) endpoints."
}

variable "api_gw_stage_cache_cluster_size" {
  type        = string
  description = "The API GW cache cluster size."
}

variable "api_gw_stage_cache_cluster_enabled" {
  type        = string
  description = "Whether cache cluster is enabled on API GW stage."
}

variable "api_gw_methods_cache_data_encrypted" {
  type        = string
  description = "Whether cache is encrypted in API GW methods."
}

variable "api_gw_methods_caching_enabled" {
  type        = string
  description = "Whether cache is enabled on the methods."
}

variable "cw_log_groups_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used to encrypt Cloudwatch log groups."
}

variable "cw_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
}

variable "vpc_id" {
  type        = string
  description = "The AWS account VPC ID."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The VPC CIDR IP range."
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of all private subnets IDs."
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "A list of all private subnets CIDR blocks."
}

variable "tags" {
  type = map(any)
}

variable "env_public_dns_id" {
  type        = string
  description = "The ID of the public DNS account/environment zone(s)."
}

variable "env_public_dns_name" {
  type        = string
  description = "The name of the public DNS account/environment zone(s)."
}

variable "app_public_dns_id" {
  type        = string
  description = "The ID of the public DNS application zone(s)."
}

variable "app_public_dns_name" {
  type        = string
  description = "The name of the public DNS application zone(s)."
}

variable "ds_public_dns_id" {
  type        = string
  description = "The ID of the public DNS DS zone(s)."
}

variable "ds_public_dns_name" {
  type        = string
  description = "The name of the public DNS DS zone(s)."
}

variable "ds_cards_records" {
  type        = list(string)
  description = "The DS cards subdomains."
}

variable "client_subdomains" {
  type        = list(string)
  description = "The clients API GWs subdomains."
}

variable "internal_dns_id" {
  type        = string
  description = "The private Route53 zone ID."
}

variable "internal_dns_name" {
  type        = string
  description = "The private Route53 zone ID."
}

variable "s3_vpc_endpoint_id" {
  type        = string
  description = "The AWS S3 VPC endpoint ID."
}

variable "s3_vpc_endpoint_prefix_id" {
  type = string
}

variable "app_acm_public_certificate_arn" {
  type        = string
  description = "The ARN of the public AWS ACM certificate per application."
}

variable "ds_acm_public_certificate_arn" {
  type        = string
  description = "The ARN of the public AWS ACM certificate for DS zone(s)."
}

variable "lb_deletion_protection" {
  type        = string
  description = "Sets the deletion protection on the internal ALB."
}

variable "i_alb_idle_timeout" {
  type        = string
  default     = "250"
  description = "The internal ALB idle timeout."
}

variable "i_lbs_listener_port" {
  type        = string
  default     = "8080"
  description = "The internal load balancers listener port."
}

variable "i_alb_listener_protocol" {
  type        = string
  default     = "HTTP"
  description = "The internal ALB listener protocol."
}

variable "i_nlb_target_group_port" {
  default     = "8080"
  description = "The internal NLB target group port."
}

variable "i_nlb_target_group_protocol" {
  type        = string
  default     = "TCP"
  description = "The internal NLB target group protocol."
}

variable "i_nlb_idle_timeout" {
  type        = string
  default     = "350"
  description = "The internal NLB idle timeout."
}

variable "i_nlb_listener_protocol" {
  type        = string
  default     = "TCP"
  description = "The internal ALB listener protocol."
}

variable "ecs_sg_id" {
  type        = string
  description = "The ECS security group ID."
}

variable "api_gw_vpc_link_id" {
  type        = string
  description = "The API GW VPC Link ID."
}

variable "i_nlb_dns_name" {
  type        = string
  description = "The internal NLB DNS name."
}

variable "truststore_pem_s3_uri" {
  type        = string
  description = "The S3 URI for the truststore.pem file needed for the mTLS in API GW."
}

variable "truststore_s3_bucket_uri" {
  type        = string
  description = "The truststore S3 bucket URI."
}

variable "api_gw_stage_name" {
  type        = string
  description = "The API GW stage name."
}

variable "assume_api_gw_role_policy" {
  type        = string
  description = "The policy for the API GW IAM role to assume."
}

variable "api_gw_2nd_level_endpoints" {
  type        = list(string)
  description = "The list of 2nd level API GW endpoints."
}

variable "api_gw_policy" {
  description = "The API GW resource-based policy."
}

variable "binary_media_types" {
  type        = set(string)
  default     = []
  description = "List of binary media types supported by the REST API."
}

variable "ds_acm_public_certificates_arns" {
  type        = list(string)
  default     = []
  description = "The list of ds card schemas public ACM certificates ARNs."
}

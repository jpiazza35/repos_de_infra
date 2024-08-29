## Provider variables
variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "internaltool"
}

## Enviornment variables
variable "tags" {
  default = {
    "Environment" : "dev"
    "Name" : "internal-tool"
  }
}


variable "environment" {
  default = "dev"
}

## s3 Bucket variables

variable "cloudfront_distribution_arn" {
  default = ""
}

variable "s3_bucket_envs" {
  default = { "Environment" : "Dev" }
}

variable "s3_bucket_name" {
  default = "website-test-module-fh"
}

variable "s3_bucket_prefix" {
  default = "dev"
}

variable "s3_bucket_acl" {
  default = "private"
}

variable "s3_bucket_configuration_index" {
  default = "index.html"
}

variable "s3_bucket_configuration_error" {
  default = "error.html"
}

variable "s3_bucket_block_public_acls" {
  default = false
}

variable "s3_bucket_block_public_policy" {
  default = false
}

variable "s3_bucket_block_public_restrict" {
  default = false
}

variable "s3_bucket_block_public_ignore_acls" {
  default = false
}
variable "s3_bucket_routing_rule_enable" {
  default = false
}
variable "s3_bucket_key_prefix_equals" {
  default = ""
}
variable "s3_bucket_replace_key_prefix_with" {
  default = ""
}
variable "load_balancer_bucket_log_name" {
  default = "load-balancer-log"
}
variable "load_balancer_account_id" {
  description = "root account id for elb "
  default     = "127311923021"
}
variable "load_balancer_bucket_log_policy_name" {
  default = "LoadBalancerLog"
}

#s3 bucket log variable & distribuion log variables
variable "s3_bucket_log_name" {
  default = "s3-bucket-log"
}
variable "s3_bucket_datalake_name" {
  default = "internal-tool-datalake"
}
variable "s3_bucket_scripts_name" {
  default = "internal-tool-scripts"
}
variable "distribution_access_log_include_cookies" {
  default = false
}
variable "distribution_access_log_prefix" {
  default = ""
}
variable "distribution_access_logging_enabled" {
  default = true
}

## CloudFront Distribution variables
#if distribution_aliases_enable = true --> aliases= distribution_aliases + var.distribution_external_aliases
variable "cloudfront_default_root_object" {
  default = "index.html"
}
variable "cloudfront_error_code" {
  default = 403
}
variable "cloudfront_response_code" {
  default = 200
}
variable "cloudfront_response_page_path" {
  default = "/index.html"
}
variable "cloudfront_origin_domain_name" {
  default = ""
}
variable "cloudfront_origin_id" {
  default = ""
}
variable "distribution_aliases_enable" {
  default = false
}
variable "distribution_aliases" {
  default = [""]
}
variable "distribution_external_aliases" {
  default = [""]
}
variable "oai_comment" {
  default = "Access to website s3 content"
}
variable "distribution_enable" {
  default = true
}
variable "distribution_ipv6" {
  default = true
}
variable "distribution_comment" {
  default = "Cloudfront distribution testing module"
}
variable "distribution_default_min_ttl" {
  default = 0
}
variable "distribution_default_ttl" {
  default = 3600
}
variable "distribution_default_max_ttl" {
  default = 86400
}
variable "distribution_price_class" {
  default = "PriceClass_100"
}
variable "distribution_restriction_type" {
  default = "whitelist"
}
variable "distribution_restriction_locations" {
  default = ["UY"]
}
variable "distribution_viewer_certificate" {
  default = true
}

### Default variables
variable "distribution_default_cache_allowed_methods" {
  default = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}
variable "distribution_default_cached_methods" {
  default = ["GET", "HEAD"]
}
variable "distribution_default_forwarded_query_string" {
  default = false
}
variable "distribution_default_cookies_forward" {
  default = "none"
}
variable "distribution_default_viewer_protocol" {
  default = "allow-all"
}
variable "distribution_acm_certificate" {
  default = ""
}
variable "distribution_ssl_support_method" {
  default = "sni-only"
}

### Ordered variables
variable "distribution_ordered_path" {
  default = "/*"
}
variable "distribution_ordered_allowed_methods" {
  default = ["GET", "HEAD", "OPTIONS"]
}
variable "distribution_ordered_cached_methods" {
  default = ["GET", "HEAD", "OPTIONS"]
}
variable "distribution_ordered_forwarded_query_string" {
  default = false
}
variable "distribution_ordered_forwarded_headers" {
  default = ["Origin"]
}
variable "distribution_ordered_forwarded_cookies" {
  default = "none"
}
variable "distribution_ordered_min_ttl" {
  default = 0
}
variable "distribution_ordered_ttl" {
  default = 86400
}
variable "distribution_ordered_max_ttl" {
  default = 31536000
}
variable "distribution_ordered_compress" {
  default = true
}
variable "distribution_ordered_viewer_protocol" {
  default = "redirect-to-https"
}


## IAM variables
variable "automation_user_name" {
  default = "dev-automation"
}
variable "automation_user_path" {
  default = "/"
}
variable "instance_secret_manager_name" {
  default = "ec2-secret-manager"
}
variable "instance_secret_manager_policiy_arn" {
  default = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
variable "redis_consumer_user_name" {
  default = "redis-consumer"
}
variable "redis_consumer_user_path" {
  default = "/"
}
variable "redis_vpc_segurity_group_name" {
  default = "redis-vpc-sg"
}

## EC2 variables

variable "instance_ami" {
  default = "instance ami"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "instance_subnet" {
  default = ["Instance subnet"]
}
variable "instance_tags" {
  default = { "Name" : "EC2 Instance" }
}
variable "instance_volume_size" {
  default = 1
}
variable "instance_volume_az" {
  default = "us-east-1a"
}
variable "instance_security_group" {
  default = [""]
}
variable "instance_user_data" {
  default = ""
}
variable "tarmac_mkd_office_static_ip" {
  default = "78.157.1.105/24"
}

## VPC variables
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "vpc_tags" {
  default = {
    Name = "main"
  }
}
variable "subnet_availability_zone" {
  default = ["us-east-1b", "us-east-1c"]
}
variable "subnet_database_cidr_block" {
  default = ["10.0.6.0/24", "10.0.7.0/24"]
}
variable "subnet_private_cidr_block" {
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}
variable "subnet_public_cidr_block" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "subnet_public_map_public_ip" {
  default = true
}
variable "route_internet_gateway_destination_cidr" {
  default = "0.0.0.0/0" #allowed all outgoing trafic
}
variable "default_vpc_segurity_group_name" {
  default = "default-vpc-sg"
}

## Aurora variables
variable "db_cluster_vpc_id" {
  default = ""
}
variable "db_cluster_subnet_private_cidr" {
  default = [""]
}
variable "db_cluster_allocated_storage" {
  default = 10
}
variable "db_cluster_max_allocated_storage" {
  default = 20 #Max free trial capacity
}
variable "db_cluster_engine" {
  default = "postgres"
}
variable "db_cluster_engine_version" {
  default = "14.2"
}
variable "db_cluster_instance_class" {
  default = "db.t3.micro"
}
variable "db_cluster_name" {
  default = "psqldb"
}
variable "db_cluster_username" {
  default = "postgres"
}
variable "db_cluster_parameter_group_name" {
  default = "default.postgres14"
}
variable "db_cluster_skip_final_snapshot" {
  default = true
}
variable "db_cluster_availability_zones" {
  default = ["us-east-1b", "us-east-1c"]
}
variable "db_cluster_storage_encrypted" {
  default = true
}
variable "db_cluster_iam_authentication_enabled" {
  default = true
}
variable "db_cluster_subnet_group_name" {
  default = "main"
}
variable "db_cluster_subnet_database_id" {
  default = ["subnet-00b645bff3ffba657", "subnet-0f8dec1852356d00e", "subnet-0f4e4991d75576475"]
}
variable "db_cluster_root_password_length" {
  default = 16
}
variable "db_cluster_identifier" {
  default = "db-instance"
}
variable "db_cluster_apply_immediately" {
  default = false
}
variable "db_cluster_tags" {
  description = "DB tags"
  type        = map(any)
  default = {
    Name = "internal-tool"
  }
}

## RDS variables
variable "db_allocated_storage" {
  default = 10
}
variable "db_max_allocated_storage" {
  default = 20 #Max free trial capacity
}
variable "db_engine" {
  default = "postgres"
}
variable "db_engine_version" {
  default = "14.2"
}
variable "db_instance_class" {
  default = "db.t3.micro"
}
variable "db_name" {
  default = "psqldb"
}
variable "db_username" {
  default = "postgres"
}
variable "db_parameter_group_name" {
  default = "default.postgres14"
}
variable "db_skip_final_snapshot" {
  default = true
}
variable "db_iam_authentication_enabled" {
  default = true
}
variable "db_subnet_group_name" {
  default = "main"
}
variable "db_subnet_group_id" {
  default = [""] # TODO: link id to the resource created by the vpc module
}
variable "db_root_password_length" {
  default = 16
}
variable "db_identifier" {
  default = "db-instance"
}

## Redis variables

variable "redis_username" {
  default = "redis"
}
variable "redis_user_acl_name" {
  default = "redis-users-acl"
}
variable "redis_node_type" {
  default = "db.t4g.small"
}
variable "redis_num_shards" {
  default = 1
}
variable "redis_snapshot_retention" {
  default = 7
}
variable "redis_subnet_group_name" {
  default = "redis-subnet-group"
}
variable "redis_parameter_group_name" {
  default = "default.memorydb-redis6"
}
variable "redis_consumer_username" {
  default = "redis-consumer"
}
variable "redis_name" {
  default = "redis-cluster"
}

## Load balancer variables
variable "load_balancer_name" {
  default = "application-load-balancer"
}
variable "load_balancer_internal" {
  default = false
}
variable "load_balancer_type" {
  default = "application"
}
variable "load_balancer_deletion_protection" {
  default = false
}
variable "load_balancer_log_prefix" {
  default = "lb-log"
}
variable "load_balancer_log_enabled" {
  default = true
}
variable "exec_command" {
  default     = true
  type        = bool
  description = "Variable to turn on or off access to Fargate tasks"
}
variable "config" {
  type = any
}

variable "db_cluster_kms_key" {
  default = "arn:aws:kms:us-east-1:616333796072:key/9eb2e173-d791-4364-a983-f4553f89dc1e"
}

variable "db_cluster_identifier_name" {
  default = "internal-tool-0"
}

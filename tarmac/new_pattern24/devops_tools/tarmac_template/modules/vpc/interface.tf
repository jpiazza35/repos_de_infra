variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_tags" {
  description = "VPC tags"
  type        = map(any)
  default = {
    Name = "main"
  }
}

variable "subnet_availability_zone" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1b", "us-east-1c"]
}

variable "subnet_private_cidr_block" {
  description = "Private subnet CIDR block"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "subnet_public_cidr_block" {
  description = "Public subnet CIDR block"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "subnet_public_map_public_ip" {
  description = "Map public ips to instances"
  type        = bool
  default     = true
}

variable "route_internet_gateway_destination_cidr" {
  description = "Destination CIDR block"
  type        = string
  default     = "0.0.0.0/0" #allowed all outgoing trafic
}

variable "default_vpc_segurity_group_name" {
  description = "Default security group name"
  type        = string
  default     = "default-vpc-sg"
}

variable "redis_vpc_segurity_group_name" {
  description = "Redis security group name"
  type        = string
  default     = "redis-vpc-sg"
}

# variable "instance_network_interface_id" {
#   description = "Network interface id"
#   type        = string
# }

variable "private_dns" {
  description = "The private DNS zone name"
  type        = string
}

variable "public_dns" {
  description = "The public DNS zone name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
variable "acc_id" {
  description = "Account ID"
  type        = list(string)
}

variable "key_name" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID to create resources in"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "local_subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "services_cidr" {
  description = "CIDR block for the services"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name prefix used to deploy the rancher management"
  type        = string
}

variable "cluster_version" {
  description = "define the eks version to deploy the cluster where Rancher'll run on"
  type        = string
}

variable "min_size" {
  description = "min"
  type        = number
}

variable "max_size" {
  description = "max size of the autoescaling cluster node groups"
  type        = number
}

variable "des_size" {
  description = "desired size of the autoescaling cluster node groups"
  type        = number
}

variable "is_eks_api_public" {
  description = "make api public available"
  type        = bool
}

variable "is_eks_api_private" {
  description = "make api private available"
  type        = bool
}

#AWS-auth Configmap roles
variable "iam_roles" {
  description = "IAM roles to add to the EKS aws-auth config maps"
  type = list(object({
    rolearn  = string
    rolename = string
    groups   = list(string)
  }))
}

variable "aws_region" {
  description = ""
  type        = string
}

variable "ebs_csi_addon_version" {
  description = ""
  type        = string
}

variable "instance_types" {
  description = "List of subnet IDs to create resources in"
  type        = list(string)
}

variable "capacity_type" {
  description = ""
  type        = string
}

variable "ami_type" {
  description = ""
  type        = string
}

variable "disk_size" {
  description = "Disk space of nodes"
  type        = number
}

variable "environment" {
  description = "tag name for the environment"
  type        = string
}

variable "aws_admin_sso_role_arn" {
  description = "ARN for the AWSAdminstratorAccess SSO Role"
  type        = string
}

variable "use_node_group_name_prefix" {
  description = "Whether to use name prefix for EKS node group name."
  type        = bool
}

variable "coredns_addon_version" {
  description = "coredns EKS cluster add-on version."
  type        = string
}

variable "kube_proxy_addon_version" {
  description = "kube-proxy EKS cluster add-on version."
  type        = string
}

variable "asg_metrics_lambda_name" {
  description = "The name for the ASG metrics enabler Lambda."
  type        = string
}

variable "asg_metrics_lambda_runtime" {
  description = "The runtime for the ASG metrics enabler Lambda."
  type        = string
}

variable "mpt_namespace" {
  description = "The namespace where MPT apps are installed."
  type        = string
}

variable "mpt_preview_namespace" {
  description = "namespace name for preview env"
  type        = string
}

variable "ps_namespace" {
  description = "The Performance Suite apps namespace"
  type        = string
}

variable "ps_preview_namespace" {
  description = "The preview Performance Suite apps namespace"
  type        = string
}
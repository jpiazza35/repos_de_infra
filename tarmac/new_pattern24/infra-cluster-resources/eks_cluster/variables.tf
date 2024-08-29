variable "aws_region" {
  type = string
}

variable "environment" {
  description = "tag name for the environment"
  type        = string
}

variable "preview_environment" {
  description = "tag name for the environment"
  type        = string
  default     = "preview"
}

variable "use_node_group_name_prefix" {
  description = "Whether to use name prefix for EKS node group name."
  type        = bool
  default     = false
}

variable "cluster_version" {
  description = "define the eks version to deploy the cluster where Rancher'll run on"
  type        = string
}

variable "services_cidr" {
  description = "CIDR block for the services"
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

variable "asg_metrics_lambda_name" {
  description = "The name for the ASG metrics enabler Lambda."
  type        = string
}

variable "asg_metrics_lambda_runtime" {
  description = "The runtime for the ASG metrics enabler Lambda."
  type        = string
}


#AWS-auth Configmap roles
variable "eks_roles" {
  description = "IAM roles to add to the EKS aws-auth config maps"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}



variable "ebs_csi_addon_version" {
  description = ""
  type        = string
}

variable "coredns_addon_version" {
  description = "coredns EKS cluster add-on version."
  type        = string
}

variable "kube_proxy_addon_version" {
  description = "kube-proxy EKS cluster add-on version."
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

variable "vault_url" {
  description = "Vault target URL"
  type        = string
}

variable "k8s_serviceaccount" {
  description = "K8s service account for vault"
  type        = string
}


variable "helm_release" {
  default = "vault-external-secrets"
}

variable "helm_repository" {
  default     = "https://charts.external-secrets.io"
  description = "The repository where the Helm chart is stored"
}

variable "helm_release_timeout_seconds" {
  description = "Time in seconds to wait for any individual kubernetes operation during a helm release."
  default     = 360
}

variable "injector_replicas" {
  default = 3
}

variable "enable_injector_leader" {
  default = true
}




# #################CERT-MANAGER  VARIABLES###################
# ##                                                       ##
# ###########################################################

# variable "cert_manager_release_namespace" {
#   description = "The Cert-Manager helm release namespace."
#   type        = string
# }

# variable "cert_manager_release_name" {
#   description = "The Cert-Manager helm release name."
#   type        = string
# }

# variable "cert_manager_chart_repository" {
#   description = "The Cert-Manager helm chart repository."
#   type        = string
# }

# variable "cert_manager_chart_name" {
#   description = "The Cert-Manager helm chart name."
#   type        = string
# }

# variable "cert_manager_chart_version" {
#   description = "The Cert-Manager helm chart version."
#   type        = string
# }

# variable "cert_manager_crds_helm_url" {
#   description = "The Cert-Manager CRDs helm chart URL."
#   type        = string
# }
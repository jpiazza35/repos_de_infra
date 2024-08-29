
module "eks" {
  # based on version 19.16 from https://github.com/terraform-aws-modules/terraform-aws-eks
  source = "../terraform-aws-eks-rd-master"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  cluster_endpoint_public_access  = var.is_eks_api_public
  cluster_endpoint_private_access = var.is_eks_api_private

  ## this is needed to allow ALB to communicate back to the API server
  cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp_1 = {
      description = "API Access from pods"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = ["10.0.0.0/8"]
    },
    ingress_nodes_ephemeral_ports_tcp_2 = {
      description = "API Access from pods"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = ["100.64.0.0/16"]
    }
  }

  cluster_addons = {
    coredns = {
      addon_version     = var.coredns_addon_version
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      addon_version     = var.kube_proxy_addon_version
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      addon_version            = var.ebs_csi_addon_version
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  #networking config

  vpc_id                    = var.vpc_id
  subnet_ids                = var.private_subnet_ids
  cluster_service_ipv4_cidr = var.services_cidr


  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    worker_node = {
      name            = "${var.cluster_name}-worker-node"
      use_name_prefix = var.use_node_group_name_prefix

      launch_template_name            = "${var.cluster_name}-launch-template"
      launch_template_use_name_prefix = false

      iam_role_use_name_prefix = false

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.des_size

      key_name = var.key_name

      instance_types = var.instance_types
      capacity_type  = var.capacity_type
      ami_type       = var.ami_type

      create_security_group  = false
      vpc_security_group_ids = [aws_security_group.eks_node_group_sg.id]

      cluster_security_group_additional_rules = {
        ingress_nodes_ephemeral_ports_tcp = {
          description = "API Access"
          protocol    = "-1"
          from_port   = 0
          to_port     = 0
          type        = "ingress"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
      tags = {
        ASG_METRICS_COLLLECTION_ENABLED = "true"
      }

    }
  }

  ## Set DNS Cluster IP on Kubelet to fix DNS issue for API
  eks_managed_node_group_defaults = {
    bootstrap_extra_args = "--kubelet-extra-args '--dns-cluster-ip 10.202.28.0/23'"
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles    = var.iam_roles
  aws_auth_accounts = var.acc_id

  tags = {
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}

resource "kubernetes_namespace" "mpt" {
  metadata {
    name = var.mpt_namespace
  }
  depends_on = [module.eks]
}

resource "kubernetes_namespace" "mpt_apps_preview" {
  count = var.environment == "prod" ? 1 : 0
  metadata {
    name = var.mpt_preview_namespace
  }
  depends_on = [module.eks]
}

resource "kubernetes_namespace" "ps_apps" {
  metadata {
    name = var.ps_namespace
  }
  depends_on = [module.eks]
}

resource "kubernetes_namespace" "ps_apps_preview" {
  count = var.environment == "prod" ? 1 : 0
  metadata {
    name = var.ps_preview_namespace
  }
  depends_on = [module.eks]
}

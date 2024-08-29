module "iam_eks_alb_controller_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "${var.cluster_name}-eks-alb-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "helm_release" "albc" {
  depends_on = [
    module.eks
  ]
  name            = "aws-load-balancer-controller"
  chart           = "aws-load-balancer-controller"
  repository      = "https://aws.github.io/eks-charts"
  namespace       = "kube-system"
  cleanup_on_fail = true
  values = [
    templatefile("${path.module}/files/helm_albc_values.yaml", {
      aws_region   = var.aws_region
      vpc_id       = var.vpc_id
      role_arn     = module.iam_eks_alb_controller_role.iam_role_arn
      cluster_Name = var.cluster_name
    })
  ]
}

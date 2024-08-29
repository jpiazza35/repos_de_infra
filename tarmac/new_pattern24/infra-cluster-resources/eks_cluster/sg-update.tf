## for the monitoring stack we need to update the default created SG

data "aws_security_group" "eks_cp" {
  filter {
    name   = "tag:aws:eks:cluster-name"
    values = [local.cluster_name]
  }

  depends_on = [module.eks_mgmt]

}


resource "aws_security_group_rule" "update_eks_cp" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.eks_cp.id
}

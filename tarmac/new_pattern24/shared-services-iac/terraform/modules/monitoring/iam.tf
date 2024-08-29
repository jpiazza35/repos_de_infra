### Grafana
resource "aws_iam_role" "grafana" {
  name                  = format("%s-grafana-role", var.cluster_name)
  assume_role_policy    = data.aws_iam_policy_document.eks_nodes_sts_grafana.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "grafana_permissions" {
  role       = aws_iam_role.grafana.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
}

resource "aws_iam_role_policy_attachment" "grafana_permissions_node" {
  role       = data.aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
}

## Thanos
resource "aws_iam_role_policy_attachment" "thanos_object_permissions_node" {
  role       = data.aws_iam_role.eks_node.name
  policy_arn = aws_iam_policy.thanos.arn
}

resource "aws_iam_role" "thanos" {
  name                  = format("%s-thanos-role", var.cluster_name)
  assume_role_policy    = data.aws_iam_policy_document.eks_oidc_thanos.json
  force_detach_policies = true
}

## Route53 Perms to nodegroup
resource "aws_iam_role_policy_attachment" "admin_to_node" {
  role       = data.aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


## permissions for cloudwatch monitoring of infra prod

resource "aws_iam_role" "grafana_infra_prod" {
  provider              = aws.infra_prod
  name                  = format("%s-grafana-role-infra-prod", var.cluster_name)
  assume_role_policy    = data.aws_iam_policy_document.eks_nodes_sts_grafana.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "grafana_permissions_infra_prod" {
  provider   = aws.infra_prod
  role       = aws_iam_role.grafana_infra_prod.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
}
resource "aws_s3_bucket" "thanos" {
  bucket = "${lower(local.cluster_name[0])}-${var.prometheus_release_name}-thanos-bucket"

  tags = {
    Name        = "${lower(local.cluster_name[0])}-${var.prometheus_release_name}-thanos-bucket"
    Environment = var.environment
  }
}

resource "aws_iam_policy" "thanos" {
  name   = "thanos_s3_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.thanos.json
}

resource "helm_release" "thanos" {
  count = var.enable_thanos_helm_chart ? 1 : 0

  name        = var.thanos_release_name
  namespace   = var.monitoring_namespace
  repository  = var.thanos_chart_repository
  chart       = var.thanos_chart_name
  version     = var.thanos_chart_version
  timeout     = var.helm_releases_timeout_seconds
  max_history = var.helm_releases_max_history

  values = [
    templatefile("${path.module}/templates/thanos_values.yml.tpl",
      {
        enabled_compact     = var.enable_thanos_compact
        monitoring_aws_role = aws_iam_role.thanos.arn
        clusterName         = terraform.workspace
        namespace           = var.monitoring_namespace
        region              = data.aws_region.current.name
        bucket              = aws_s3_bucket.thanos.id

      }
  )]

  depends_on = [
    helm_release.prometheus
  ]

  lifecycle {
    ignore_changes = [keyring]
  }
}

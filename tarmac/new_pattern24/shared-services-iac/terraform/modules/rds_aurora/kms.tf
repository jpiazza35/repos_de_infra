resource "aws_kms_key" "db_cluster" {
  is_enabled  = true
  description = "Encryption key for Aurora Cluster"
  policy      = data.aws_iam_policy_document.db_cluster_kms_key_policy.json
}

resource "aws_kms_alias" "db_cluster" {
  name          = "alias/${var.tags["env"]}-${var.tags["product"]}-${var.tags["service"]}-cluster"
  target_key_id = aws_kms_key.db_cluster.arn
}

resource "aws_kms_key" "db_cluster_instance_insights" {
  is_enabled  = true
  description = "Encryption key for Aurora Cluster Instance Insights"
  policy      = data.aws_iam_policy_document.db_cluster_instance_insights_managed_policy.json
}

resource "aws_kms_alias" "db_cluster_instance_insights" {
  name          = "alias/${var.tags["env"]}-${var.tags["product"]}-${var.tags["service"]}-cluster-instance-insights"
  target_key_id = aws_kms_key.db_cluster_instance_insights.arn
}

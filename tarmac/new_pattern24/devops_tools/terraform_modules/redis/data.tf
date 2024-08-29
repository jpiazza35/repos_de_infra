data "template_file" "redis_lambdas_cw_access" {
  template = file("${path.module}/iam_policies/redis_lambdas_cw_access.json")
}

data "aws_caller_identity" "current" {
}

data "template_file" "sqs" {
  template = file("${path.module}/iam_policies/sqs-policy.json")

  vars = {
    aws_account_id                 = data.aws_caller_identity.current.account_id
    region                         = var.region
    sqs_queue_name                 = element(concat(aws_sqs_queue.sqs.*.name, tolist([""])), 0)
    vpc_endpoint_id                = var.sqs_vpc_endpoint_id
    proxy_dev_aws_account_id       = var.proxy_dev_aws_account_id
    proxy_test_aws_account_id      = var.proxy_test_aws_account_id
    proxy_prod_aws_account_id      = var.proxy_prod_aws_account_id
    shared_services_aws_account_id = var.shared_services_aws_account_id
    security_aws_account_id        = var.security_aws_account_id
    networking_aws_account_id      = var.networking_aws_account_id
    infra_code_aws_account_id      = var.infra_code_aws_account_id
    master_aws_account_id          = var.master_aws_account_id
    networking_aws_account_id      = var.networking_aws_account_id
  }
}
# Create admin policy
resource "vault_policy" "admin_policy" {
  count  = local.count
  name   = "admins"
  policy = file("${path.module}/policies/admin_policy.hcl")
}

resource "vault_policy" "kv_read" {
  count  = local.count
  name   = "kv-read"
  policy = file("${path.module}/policies/kv_read.hcl")
}

resource "vault_policy" "k8s" {
  count = local.create_k8s_auth
  name  = format("%s-kv-rw", var.cluster_name)

  policy = templatefile("${path.module}/policies/k8s.hcl", {
    CLUSTER_NAME = var.cluster_name }
  )
}

resource "vault_policy" "devops" {
  count = local.count
  name  = "devops"

  policy = file("${path.module}/policies/devops.hcl")
}

resource "vault_policy" "data_platform" {
  count = local.count
  name  = "data-platform"

  policy = file("${path.module}/policies/data_platform.hcl")
}

resource "vault_policy" "itops" {
  count = local.count
  name  = "itops"

  policy = file("${path.module}/policies/itops.hcl")
}

resource "vault_policy" "pki_cert_issuer" {
  count = local.create_k8s_auth
  name  = format("%s-cert-issuer", var.cluster_name)

  policy = templatefile("${path.module}/policies/vault_cert_issuer.hcl", {
    CLUSTER_NAME = var.cluster_name }
  )
}
resource "vault_policy" "app_devs" {
  count = local.count
  name  = "app-devs"

  policy = file("${path.module}/policies/app_devs.hcl")
}

resource "vault_policy" "aws" {
  count = local.create_aws_auth
  name  = format("%s-kv-rw", data.aws_caller_identity.current.account_id)

  policy = templatefile("${path.module}/policies/aws.hcl", {
    ACCOUNT_ID = data.aws_caller_identity.current.account_id
    }
  )
}

resource "vault_policy" "ces_devs" {
  count  = local.count
  name   = "ces-devs"
  policy = file("${path.module}/policies/ces_devs.hcl")
}

resource "vault_policy" "qa_team" {
  count  = local.count
  name   = "qa"
  policy = file("${path.module}/policies/qa.hcl")
}

resource "vault_policy" "data_governance" {
  count  = local.count
  name   = "data-governance"
  policy = file("${path.module}/policies/data_governance.hcl")
}

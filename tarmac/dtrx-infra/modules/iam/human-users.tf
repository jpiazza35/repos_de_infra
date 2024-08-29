resource "aws_iam_user" "darko_tarmac" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "darko.klincharski"

  tags = var.tags
}

resource "aws_iam_user" "antonio_tarmac" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "antonio.nedanoski"

  tags = var.tags
}

resource "aws_iam_user" "ezequiel_tarmac" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "ezequiel.burgo"

  tags = var.tags
}

resource "aws_iam_user" "hector_tarmac" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "hector.bauzan"

  tags = var.tags
}

resource "aws_iam_user" "dominic_ruettimann_dtcloud" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "dominic.ruettimann"

  tags = var.tags
}


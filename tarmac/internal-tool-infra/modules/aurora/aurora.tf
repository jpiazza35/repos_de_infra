resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier      = var.db_cluster_identifier
  engine                  = var.db_cluster_engine
  engine_version          = var.db_cluster_engine_version
  availability_zones      = var.db_cluster_availability_zones
  database_name           = var.db_cluster_database_name
  master_username         = var.db_cluster_master_username
  master_password         = random_password.root-password.result
  backup_retention_period = var.db_cluster_backup_retention_period
  vpc_security_group_ids  = [aws_security_group.aurora_vpc_segurity_group.id]
  storage_encrypted       = var.db_cluster_storage_encrypted
  kms_key_id              = var.db_cluster_kms_key
  db_subnet_group_name    = aws_db_subnet_group.db_cluster_subnet_group.name
  skip_final_snapshot     = true
  apply_immediately       = var.db_cluster_apply_immediately

}

resource "aws_db_subnet_group" "db_cluster_subnet_group" {
  name = var.db_cluster_subnet_group_name
  #subnet_ids = module.vpc.subnet_database_id
  subnet_ids = var.db_cluster_subnet_database_id
  tags       = var.db_cluster_tags
}

resource "random_password" "root-password" {
  length           = var.db_cluster_root_password_length
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "aws_kms_key" "db_cluster" {
  description = "Encryption key for Internal Aurora Cluster"
  policy      = data.aws_iam_policy_document.db_cluster_kms_key_policy.json
}

resource "aws_kms_alias" "db_cluster" {
  name          = "alias/internaltool"
  target_key_id = aws_kms_key.db_cluster.key_id
}

data "aws_iam_policy_document" "db_cluster_kms_key_policy" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow use of the key in dev"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.aws_acc_id}:user/tarmacInternalCircleCI",
      ]
    }
  }

  statement {
    sid       = "Allow use of the key"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::671035760640:root"]
    }
  }
}

resource "aws_rds_cluster_instance" "db_cluster_instance" {
  count                = 1
  identifier           = var.db_cluster_identifier_name
  cluster_identifier   = aws_rds_cluster.db_cluster.id
  instance_class       = var.db_cluster_instance_class
  engine               = aws_rds_cluster.db_cluster.engine
  engine_version       = aws_rds_cluster.db_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.db_cluster_subnet_group.name
}







resource "aws_db_instance" "db" {
  allocated_storage                   = var.db_allocated_storage
  max_allocated_storage               = var.db_max_allocated_storage
  engine                              = var.db_engine
  engine_version                      = var.db_engine_version
  instance_class                      = var.db_instance_class
  db_name                             = var.db_name
  username                            = var.db_username
  password                            = random_password.root-password.result
  parameter_group_name                = var.db_parameter_group_name
  skip_final_snapshot                 = var.db_skip_final_snapshot
  iam_database_authentication_enabled = var.db_iam_authentication_enabled
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_group.name
  identifier                          = var.db_identifier
  vpc_security_group_ids              = [aws_security_group.rds_vpc_segurity_group.id]
  publicly_accessible                 = var.db_publicly_accessible
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.db_subnet_group_id
  tags       = var.db_tags
}

resource "random_password" "root-password" {
  length           = var.db_root_password_length
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


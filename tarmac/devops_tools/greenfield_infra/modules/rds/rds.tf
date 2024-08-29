resource "aws_db_instance" "psql" {
  identifier                = "${var.tags["env"]}-${var.tags["projectname"]}-db"
  final_snapshot_identifier = "${var.tags["env"]}-${var.tags["projectname"]}-rds-psql-v001"
  allocated_storage         = 30
  storage_type              = "gp2"
  storage_encrypted         = "false"
  engine                    = "postgres"
  engine_version            = "12.2"
  instance_class            = var.db_instance_class
  username                  = "dbuser"
  password                  = var.rds_password
  db_subnet_group_name      = aws_db_subnet_group.psql.name
  multi_az                  = "false"
  backup_retention_period   = "7"
  vpc_security_group_ids    = [aws_security_group.sg-rds.id]
}

resource "aws_db_subnet_group" "psql" {
  name       = "${var.tags["service"]}-${var.tags["env"]}-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.tags["env"]}-${var.tags["projectname"]}-db-subnet-group"
  }
}
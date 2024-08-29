resource "aws_ecr_repository_policy" "ecr_server" {
  repository = aws_ecr_repository.server.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "ecr_server_prod" {
  repository = aws_ecr_repository.server_prod.name
  policy     = data.template_file.ecr_read_write_access_prod.rendered
}

resource "aws_ecr_repository_policy" "ecr_admin" {
  repository = aws_ecr_repository.admin.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "ecr_admin_prod" {
  repository = aws_ecr_repository.admin_prod.name
  policy     = data.template_file.ecr_read_write_access_prod.rendered
}

resource "aws_ecr_repository_policy" "db_seeder" {
  repository = aws_ecr_repository.db_seeder.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "ecea" {
  repository = aws_ecr_repository.ecea.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "ecea_prod" {
  repository = aws_ecr_repository.ecea_prod.name
  policy     = data.template_file.ecr_read_write_access_ecea_prod.rendered
}

resource "aws_ecr_repository_policy" "da_crs" {
  repository = aws_ecr_repository.da_crs.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "da_crs_prod" {
  repository = aws_ecr_repository.da_crs_prod.name
  policy     = data.template_file.ecr_read_write_access_da_prod.rendered
}

resource "aws_ecr_repository_policy" "da_cas" {
  repository = aws_ecr_repository.da_cas.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "da_cas_prod" {
  repository = aws_ecr_repository.da_cas_prod.name
  policy     = data.template_file.ecr_read_write_access_da_prod.rendered
}

resource "aws_ecr_repository_policy" "da_api" {
  repository = aws_ecr_repository.da_api.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "da_api_prod" {
  repository = aws_ecr_repository.da_api_prod.name
  policy     = data.template_file.ecr_read_write_access_da_prod.rendered
}

resource "aws_ecr_repository_policy" "da_admin" {
  repository = aws_ecr_repository.da_admin.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "da_admin_prod" {
  repository = aws_ecr_repository.da_admin_prod.name
  policy     = data.template_file.ecr_read_write_access_da_prod.rendered
}

resource "aws_ecr_repository_policy" "da_auth" {
  repository = aws_ecr_repository.da_auth.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "da_auth_prod" {
  repository = aws_ecr_repository.da_auth_prod.name
  policy     = data.template_file.ecr_read_write_access_da_prod.rendered
}

resource "aws_ecr_repository_policy" "da_cli" {
  repository = aws_ecr_repository.da_cli.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "da_cli_prod" {
  repository = aws_ecr_repository.da_cli_prod.name
  policy     = data.template_file.ecr_read_write_access_da_prod.rendered
}

resource "aws_ecr_repository_policy" "apache_proxy" {
  repository = aws_ecr_repository.apache_proxy.name
  policy     = data.template_file.ecr_read_write_access.rendered
}

resource "aws_ecr_repository_policy" "apache_proxy_prod" {
  repository = aws_ecr_repository.apache_proxy_prod.name
  policy     = data.template_file.ecr_read_write_access_prod.rendered
}
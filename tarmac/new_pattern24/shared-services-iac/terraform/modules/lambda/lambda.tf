locals {
  code_hash         = filemd5("${path.root}/${var.properties.working_dir}/${var.properties.codefilename}")
  requirements_hash = filemd5("${path.root}/${var.properties.working_dir}/${var.properties.requirementsfilename}")
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.properties.function_name
  description   = var.properties.description
  handler       = var.properties.handler
  filename      = data.archive_file.lambda_archive.output_path
  # source_code_hash = data.archive_file.lambda_archive.output_base64sha256
  role          = aws_iam_role.lambda_role.arn
  architectures = [var.properties.architectures]
  runtime       = var.properties.runtime_version
  timeout       = var.properties.timeout
  memory_size   = var.properties.memory_size
  ephemeral_storage {
    size = var.properties.ephemeral_storage
  }

  vpc_config {
    subnet_ids         = data.aws_subnets.private.ids
    security_group_ids = [aws_security_group.main.id]
  }

  dynamic "environment" {
    for_each = [var.properties.variables]
    content {
      variables = environment.value
    }
  }

  tags = var.tags
}

# This resource triggers deployment of the lambda function only if there are changes in the code or requirements.
resource "null_resource" "install_lambda" {
  provisioner "local-exec" {
    command     = <<EOT
      pip3 install -r ${var.properties.requirementsfilename} -t . --upgrade
    EOT
    working_dir = "${path.root}/${var.properties.working_dir}/"
  }
  triggers = {
    lambda_code_hash       = local.code_hash
    requirements_code_hash = local.requirements_hash
  }
}

data "archive_file" "lambda_archive" {
  type             = "zip"
  output_path      = "${path.root}/${var.properties.working_dir}/${local.code_hash}_${local.requirements_hash}.zip"
  output_file_mode = "0666"
  source_dir       = "${path.root}/${var.properties.working_dir}/"
  depends_on       = [null_resource.install_lambda]
}

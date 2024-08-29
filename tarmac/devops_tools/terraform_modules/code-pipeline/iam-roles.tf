resource "aws_iam_role" "code_pipeline_role" {
  name = "${var.tags["Environment"]}-${var.tags["Application"]}-pipeline-role"
  path = "/service-role/"

  assume_role_policy = data.template_file.assume_code_pipeline.rendered
}

resource "aws_iam_role" "cwe_code_pipeline_role" {
  name = "${var.tags["Environment"]}-${var.tags["Application"]}-cwe-pipeline-role"
  path = "/service-role/"

  assume_role_policy = data.template_file.assume_cwe.rendered
}

resource "aws_iam_role" "cloudtrail_cw_logs" {
  count = var.create_pipeline_trail ? 1 : 0
  name  = "${var.tags["Environment"]}-${var.tags["Product"]}-cloudtrail-cw-logs-role"
  path  = "/"

  assume_role_policy = data.template_file.assume_cloudtrail.rendered
}
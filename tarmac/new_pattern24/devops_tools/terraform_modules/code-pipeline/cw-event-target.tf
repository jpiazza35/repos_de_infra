resource "aws_cloudwatch_event_target" "s3_pipeline_target" {
  target_id = "Code-Pipeline"
  arn       = aws_codepipeline.codepipeline.arn
  rule      = aws_cloudwatch_event_rule.s3_pipeline_cwe.name
  role_arn  = aws_iam_role.cwe_code_pipeline_role.arn
}
resource "aws_sns_topic" "sns" {
  count        = local.default
  name         = local.sns_name
  display_name = local.sns_display_name
  tags = merge(
    var.tags,
    tomap(
      {
        "Name"           = format("%s-%s-alb", var.env, var.app)
        "SourcecodeRepo" = "https://github.com/clinician-nexus/shared-services-iac"
      }
    )
  )

}

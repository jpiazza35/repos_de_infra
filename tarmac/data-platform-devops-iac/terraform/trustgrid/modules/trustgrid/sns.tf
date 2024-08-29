resource "aws_sns_topic" "sns" {
  name         = local.sns_name
  display_name = local.sns_display_name
  tags = merge(
    var.tags,
    tomap(
      {
        "Name" = format("%s-%s-asg", var.env, var.app)
      }
    )
  )

}

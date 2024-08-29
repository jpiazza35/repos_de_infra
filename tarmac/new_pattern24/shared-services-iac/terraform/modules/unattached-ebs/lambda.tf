module "lambda" {
  source = "../lambda"

  properties = merge(
    var.lambda,
    {
      inline_policies = [
        {
          name = "unattachedEBSLambda"
          policy = {
            Version = "2012-10-17"
            Statement = [
              {
                "Sid" : "UnattachedEBSLambdaPolicy",
                "Effect" : "Allow",
                "Action" : [
                  "cloudtrail:LookupEvents",
                  "cloudtrail:StartLogging",
                  "cloudtrail:GetTrailStatus",
                  "logs:CreateLogGroup",
                  "logs:PutLogEvents",
                  "ssm:CreateOpsItem",
                  "cloudtrail:DescribeTrails",
                  "ec2:DescribeVolumeAttribute",
                  "logs:CreateLogStream",
                  "sns:Publish",
                  "ec2:DescribeVolumeStatus",
                  "cloudtrail:CreateTrail",
                  "ec2:DescribeVolumes",
                  "ec2:CreateNetworkInterface",
                  "ec2:DescribeNetworkInterfaces",
                  "ec2:DeleteNetworkInterface",
                ],
                "Resource" : ["*"]
              }
            ]
          }
        }
      ]
    },
    {
      variables = merge(
        var.lambda.variables,
        {
          "SNS_ARN"           = aws_sns_topic.unattached_ebs.arn # The ARN of the SNS topic to which the Lambda function sends notifications. 
          "SSM_AUTOMATION_ID" = "AWS-CreateSnapshot"             ## Provide the default Automation document you want to associate with the OpsItems that the Lambda function writes to the OpsCenter. 
        }

      )
    }
  )
  tags = var.tags

}

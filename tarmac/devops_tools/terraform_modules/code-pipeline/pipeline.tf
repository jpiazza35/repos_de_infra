resource "aws_codepipeline" "codepipeline" {
  name     = "${var.tags["Environment"]}-${var.tags["Application"]}-pipeline"
  role_arn = aws_iam_role.code_pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.s3_code_pipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "S3-Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["s3bucket-output"]

      configuration = {
        S3Bucket             = aws_s3_bucket.s3_pipeline_source.id
        S3ObjectKey          = "imagedefinitions.json.zip"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "ECS-Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["s3bucket-output"]
      version         = "1"

      configuration = {
        ClusterName       = "${var.tags["Environment"]}-${var.tags["Product"]}"
        ServiceName       = "my-application-service"
        DeploymentTimeout = "20"
      }
    }
  }
}
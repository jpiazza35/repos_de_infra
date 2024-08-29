# Create local file containing run task command
resource "local_file" "file_task_da_cli" {
  count    = var.create_da_cli_local_file ? 1 : 0
  content  = "Run task definition with the following command: \n\naws ecs run-task --task-definition ${aws_ecs_task_definition.ecs_efs[0].family} --cluster ${var.cluster_name} --launch-type FARGATE --network-configuration 'awsvpcConfiguration={subnets=${jsonencode(var.private_subnets)},securityGroups=[${jsonencode(aws_security_group.ecs.id)}],assignPublicIp=DISABLED}' --region ${var.region} --profile ${var.profile}"
  filename = "${var.tags["Environment"]}-${var.tags["Application"]}-run-task.txt"
}


# Upload file to S3 bucket
resource "aws_s3_bucket_object" "file_task_to_s3" {
  count  = var.upload_local_file ? 1 : 0
  bucket = "${var.tags["Environment"]}-${var.tags["Product"]}-auxiliary-files-bucket"
  key    = "${var.tags["Environment"]}-${var.tags["Application"]}-run-task.txt"
  source = "${var.tags["Environment"]}-${var.tags["Application"]}-run-task.txt"
  etag   = filemd5("${var.tags["Environment"]}-${var.tags["Application"]}-run-task.txt")

  depends_on = [
    local_file.file_task_da_cli,
    local_file.file_task_dbseeder
  ]
}
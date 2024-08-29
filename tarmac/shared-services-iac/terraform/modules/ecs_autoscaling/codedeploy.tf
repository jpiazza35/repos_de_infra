/* 
resource "aws_codedeploy_app" "deploy" {
  compute_platform = "ECS"
  name             = "ml-models-ecs-deploy"
}

resource "aws_codedeploy_deployment_group" "group" {
  app_name               = aws_codedeploy_app.deploy.name
  deployment_group_name  = "ml-models-ecs-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy.arn

  blue_green_deployment_config {

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      # time to wait after a succesful deployment before terminating old instances - time for rollback
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.cluster.name
    service_name = aws_ecs_service.service.name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = concat(
          [
            aws_lb_listener.listener["blue"].arn, ##https
          ],

        )
      }

      test_traffic_route {
        listener_arns = [
          aws_lb_listener.listener["green"].arn,
        ]
      }

      target_group {
        name = aws_lb_target_group.task["blue"].name
      }

      target_group {
        name = aws_lb_target_group.task["green"].name
      }
    }
  }
} */

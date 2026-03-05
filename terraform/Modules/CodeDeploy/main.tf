# CodeDeploy Application
resource "aws_codedeploy_app" "main" {
  name             = "ecs-codedeploy-app"
  compute_platform = "ECS"
}
# CodeDeploy deployment group
resource "aws_codedeploy_deployment_group" "main" {
  app_name               = aws_codedeploy_app.main.name
  deployment_group_name  = "blue-green-deployment-group"
  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"
  service_role_arn       = var.codedeploy_role
  #depends_on = [ ]



  # Automatic rollback on deployment failure
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"] # if deployment fails, it will automatically rollback to the previous version
  }
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = var.aws_cluster_name
    service_name = var.aws_service_name
  }


  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL" # This option allows CodeDeploy to manage the traffic shifting between the blue and green environments during the deployment process.
    deployment_type   = "BLUE_GREEN"
  }

  # Load balancer configuration for traffic shifting
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_arn] # reference to the ARN of the ALB listener
      }

      target_group {
        name = var.blue_tg_name
      }

      target_group {
        name = var.green_tg_name
      }
    }
  }
}
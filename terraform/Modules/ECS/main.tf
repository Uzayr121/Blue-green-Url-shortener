# ECS cluster 

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name


}


resource "aws_ecs_task_definition" "task_def" {
  family                   = "blue-green-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = var.ecs_task_execution_role
  task_role_arn      = var.ecs_task_role

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "903497499610.dkr.ecr.eu-west-2.amazonaws.com/url-shortener:latest"
      environment = [
        {
          name  = "TABLE_NAME"
          value = var.dyanmodb_table_name
        }
      ]
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/blue-green-app"
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "app"
          "awslogs-create-group"  = "true"

        }
      }
    }

  ])

}
# ECS Service configured for blue-green deployment
resource "aws_ecs_service" "app" {
  name                              = var.ecs_service_name
  cluster                           = aws_ecs_cluster.cluster.id
  task_definition                   = aws_ecs_task_definition.task_def.arn
  desired_count                     = 2
  health_check_grace_period_seconds = 240
  launch_type                       = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet_1_id, var.private_subnet_2_id]
    security_groups  = [var.ecs_sg]
    assign_public_ip = false
  }

  load_balancer {
    container_name   = var.container_name
    container_port   = 8080
    target_group_arn = var.blue_tg_arn
  }
  deployment_controller {
    type = "CODE_DEPLOY"
  }


  # preventing changes to task definition, load balancer and desired count when we run terraform apply after the initial deployment, as these are managed by CodeDeploy during the blue-green deployment process
  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer,
      desired_count,
    ]
  }
}


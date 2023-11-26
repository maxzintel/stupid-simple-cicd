data "aws_ssm_parameter" "example_app_image_tag" {
  name = "/production/example-app/config/imageTag"
}

# Create ECS services to run specified task definitions - this is what actually runs our apps
resource "aws_ecs_service" "example_app_service" {
  name            = "ExampleAppService"
  cluster         = "YourCluster"
  task_definition = aws_ecs_task_definition.example_app_task.arn
  launch_type     = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count   = 1 # Start with 1 task, can adjust based on need
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100

  network_configuration {
    subnets = ["subnet-123","subnet-234","subnet-345"] # deployed to our private subnets because we want to control traffic here - should not be completely exposed to the world.
    security_groups = ["sg-123"]
  }

  # the load balancer that fronts the example-app ecs task.
  load_balancer {
    container_name   = "example_app"
    container_port   = 3000
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:${YOUR_AWS_ACCOUNT_NUMBER}:targetgroup/example-app-tg/123"
  }
}

resource "aws_ecs_task_definition" "example_app_task" {
  family                   = "example_app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024" # 1 full CPU
  memory                   = "2048" # 2GB memory 
  execution_role_arn       = "arn:aws:iam::${YOUR_AWS_ACCOUNT_NUMBER}:role/ecs_execution_role"
  task_role_arn            = "arn:aws:iam::${YOUR_AWS_ACCOUNT_NUMBER}:role/ecs_task_role"

  container_definitions = jsonencode([{
    name  = "example_app"
    image = "${YOUR_AWS_ACCOUNT_NUMBER}.dkr.ecr.us-east-1.amazonaws.com/example-app:${data.aws_ssm_parameter.example_app_image_tag.value}"

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = "example_app_logs"
        awslogs-region = "us-east-1"
        awslogs-stream-prefix = "example_app"
      }
    }

    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]

    secrets = [
      {
        name = "AWS_DYNAMO_DB_TABLE_NAME",
        valueFrom = "arn:aws:ssm:us-east-1:${YOUR_AWS_ACCOUNT_NUMBER}:parameter/production/example-app/config/awsDynamoDBTableName"
      }
    ]
  }])
}

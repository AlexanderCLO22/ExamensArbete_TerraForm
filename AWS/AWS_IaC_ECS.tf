
# BEGIN: ECS Cluster
resource "aws_ecs_cluster" "my_aws_cluster" {
  name = "AWS_Cluster"
}
# END: ECS Cluster

# BEGIN: ECS Task Definition
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 4096
  execution_role_arn = "arn:aws:iam::183961945411:role/ecsTaskExecutionRole"

  container_definitions    = jsonencode([
    {
      name      = "my-app"
      image     = "aleoje/thesnakegame:latest"
      environment = [
        {
          name  = "MONGODB_CONNECTION_STRING"
          value = "mongodb+srv://AleOje:sIS81pn7svhDCnUm@examensarbete.jv5yrm5.mongodb.net/"
        }
      ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
# END: ECS Task Definition

# BEGIN: ECS Service
resource "aws_ecs_service" "my_ecs_service" {
  name            = "ECS_Service"
  cluster         = aws_ecs_cluster.my_aws_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets = ["subnet-041b5faa7059bcc49", "subnet-0938d7dd99e26814a", "subnet-03f641fc52c51263b"]
    security_groups = [aws_security_group.my_security_group.id]
    assign_public_ip = true
  }
}
# END: ECS Service

# BEGIN: Security Group
resource "aws_security_group" "my_security_group" {
  name        = "ExamensSecurityGroup"
  description = "Security group for ECS Cluster"

  ingress {
    from_port   = 80
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "For Docker"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    description = "MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
}
# END: Security Group

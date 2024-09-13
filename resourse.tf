terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Update to a compatible version
    }
  }

  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-west-2"  # Replace with your preferred region
}

# Security Group for the Load Balancer
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb_sg-"
  vpc_id      = "vpc-0ce8fa4e1061cad2a"  # Replace with your VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}

# Application Load Balancer
resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-0c55d0821d53fa18e", "subnet-033a37e04db6c3bc2"]  # Replace with your subnet IDs

  enable_deletion_protection = false
  idle_timeout               = 60
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "example-alb"
  }
}

# Target Group for the Load Balancer
resource "aws_lb_target_group" "example" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0ce8fa4e1061cad2a"  # Replace with your VPC ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "example-target-group"
  }
}

# Listener for the Load Balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

# Launch Configuration for the Auto Scaling Group
resource "aws_launch_configuration" "example" {
  name          = "example-launch-configuration"
  image_id      = "ami-0bfddf4206f1fa7b9"  # Replace with a valid AMI ID for your region
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
  }

  # No tag block needed here
}

# Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = ["subnet-031a1959908975a09", "subnet-0518ec52b70e06cea"]  # Replace with your subnet IDs

  tag {
    key                 = "Name"
    value               = "example-instance"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Attach Auto Scaling Group to the Target Group
  force_delete = true
}

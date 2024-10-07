terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region  # Use a variable for region
}

variable "aws_region" {
  default = "ap-south-1"
}

# Create a target group for "test"
resource "aws_lb_target_group" "sample_tg_test" {
  name     = "test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-00f3cb88faf32bbad"  # Replace with your actual VPC ID

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
  }
}

# Attach the first instance to the target group
resource "aws_lb_target_group_attachment" "tg_attachment_test_instance1" {
  target_group_arn = aws_lb_target_group.sample_tg_test.arn
  target_id        = "i-00af0caed6be51627"  # Replace with your actual first instance ID
  port             = 80
}

# Attach the second instance to the target group
resource "aws_lb_target_group_attachment" "tg_attachment_test_instance2" {
  target_group_arn = aws_lb_target_group.sample_tg_test.arn
  target_id        = "i-0ae5a8676a6eac867"  # Replace with your actual second instance ID
  port             = 80
}

# Create a target group for "test1" (if needed)
resource "aws_lb_target_group" "sample_tg_test1" {
  name     = "test1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-00f3cb88faf32bbad"  # Replace with your actual VPC ID

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
  }
}
# Create a security group for the ALB
resource "aws_security_group" "lb_sg" {
  vpc_id = "vpc-00f3cb88faf32bbad"  # Your existing VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to your needs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the Application Load Balancer
resource "aws_lb" "main" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-0e2a81b57c11f927c", "subnet-086b68bba4c1bd510"]  # Use your existing subnet ID

  enable_deletion_protection = false
}

# Create a listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.sample_tg_test.arn
  }
}

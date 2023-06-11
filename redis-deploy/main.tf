terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = var.region
}

data "aws_ami" "redis_ami" {
  most_recent = true
  owners      = ["self"]
  tags = {
    Name = var.ami
  }
}

resource "aws_launch_configuration" "redis_launch_config" {
  instance_type   = var.instance_type
  image_id        = data.aws_ami.redis_ami.id
  security_groups = [var.sg_redis]
  key_name        = var.keypair_name
}

resource "aws_elb" "redis_elb" {
  name               = "${var.name}-elb"
  availability_zones = var.availability_zones
  security_groups    = [var.sg_redis]

  listener {
    instance_port     = 6379
    instance_protocol = "TCP"
    lb_port           = 6379
    lb_protocol       = "TCP"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    target              = "TCP:6379"
    interval            = 30
  }

  tags = {
    "Name" : var.name
    "Owner" : var.owner,
    "Project" : var.project,
    "EC2_ECONOMIZATOR" : var.ec2_economizator,
    "CustomerID" : var.customerid
  }
}

resource "aws_autoscaling_group" "redis_autoscaling_group" {
  name                 = var.name
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  launch_configuration = aws_launch_configuration.redis_launch_config.name
  load_balancers       = [aws_elb.redis_elb.name]
  availability_zones   = var.availability_zones

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.name
  }

  tag {
    key                 = "Owner"
    propagate_at_launch = true
    value               = var.owner
  }
  tag {
    key                 = "CustomerID"
    propagate_at_launch = true
    value               = var.customerid
  }
  tag {
    key                 = "Project"
    propagate_at_launch = true
    value               = var.project
  }
  tag {
    key                 = "EC2_ECONOMIZATOR"
    propagate_at_launch = true
    value               = var.ec2_economizator
  }
}

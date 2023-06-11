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

data "aws_ami" "elk_ami" {
  most_recent = true
  owners      = ["self"]
  tags = {
    Name = var.ami
  }
}

resource "aws_launch_configuration" "elk_launch_config" {
  instance_type   = var.instance_type
  image_id        = data.aws_ami.elk_ami.id
  security_groups = [var.sg_elk]
  key_name        = var.keypair_name
  root_block_device {
    volume_size = 15
  }
  user_data = "${file("status_pod.sh")}"
}

resource "aws_elb" "elk_elb" {
  name               = "${var.name}-elb"
  availability_zones = var.availability_zones
  security_groups    = [var.sg_elk]

  listener {
    instance_port     = 8200
    instance_protocol = "HTTP"
    lb_port           = 8200
    lb_protocol       = "HTTP"
  }
  listener {
    instance_port     = 5601
    instance_protocol = "HTTP"
    lb_port           = 5601
    lb_protocol       = "HTTP"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    target              = "HTTP:8200/"
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

resource "aws_autoscaling_group" "elk_autoscaling_group" {
  name                 = var.name
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  launch_configuration = aws_launch_configuration.elk_launch_config.name
  load_balancers       = [aws_elb.elk_elb.name]
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
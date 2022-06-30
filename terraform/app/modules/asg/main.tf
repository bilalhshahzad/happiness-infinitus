locals {
  applied_tags                = merge(var.custom_tags, var.base_tags)
}

data "aws_ami" "ubuntu_ami" {
  most_recent                 = true
  owners                      = ["099720109477"]

  filter {
    name                      = "name"
    values                    = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
        name                  = "virtualization-type"
        values                = ["hvm"]
    }
}

data "template_file" "bootstrap" {
    template                  = "${file("${path.module}/bootstrap.tpl")}"
      vars = {
        efsid                 = var.efsid
        rdshost               = var.rdshost
        db_user               = var.db_user
        db_password           = var.db_password
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix                 = "web_node_config"
  image_id                    = data.aws_ami.ubuntu_ami.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "wordpress"
  security_groups             = [var.sg_web_id]
  user_data                   = data.template_file.bootstrap.rendered
}

resource "aws_autoscaling_group" "this" {
  name                        = "wp-boxen-asg"
  launch_configuration        = aws_launch_configuration.this.name
  desired_capacity            = 2
  min_size                    = 1
  max_size                    = 5
  vpc_zone_identifier         = [var.subnet_public-a_id,var.subnet_public-b_id]
  target_group_arns           = [var.lb_target_group_arn]
  #load_balancers              = [var.lb_wp_id]
  lifecycle {
    create_before_destroy     = true
  }
}

resource "aws_autoscaling_policy" "wordpresspolicy" {
  name                        = "wp-boxen-policy-high"
  scaling_adjustment          = 1
  adjustment_type             = "ChangeInCapacity"
  cooldown                    = 300
  autoscaling_group_name      = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "wordpresspolicylow" {
  name                        = "wp-boxen-policy-low"
  scaling_adjustment          = -1
  adjustment_type             = "ChangeInCapacity"
  cooldown                    = 300
  autoscaling_group_name      = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "cpuhigh" {
  alarm_name                  = "wp-boxen-cpu-high"
  comparison_operator         = "GreaterThanOrEqualToThreshold"
  evaluation_periods          = "2"
  metric_name                 = "CPUUtilization"
  namespace                   = "AWS/EC2"
  period                      = "60"
  statistic                   = "Average"
  threshold                   = "80"

  dimensions = {
    AutoScalingGroupName      = aws_autoscaling_group.this.name
  }

  alarm_description           = "I will monitor EC2 cpu utilisation"
  alarm_actions               = [aws_autoscaling_policy.wordpresspolicy.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpulow" {
  alarm_name                  = "wp-boxen-cpu-low"
  comparison_operator         = "LessThanOrEqualToThreshold"
  evaluation_periods          = "2"
  metric_name                 = "CPUUtilization"
  namespace                   = "AWS/EC2"
  period                      = "60"
  statistic                   = "Average"
  threshold                   = "25"

  dimensions = {
    AutoScalingGroupName      = aws_autoscaling_group.this.name
  }

  alarm_description           = "I will monitor EC2 cpu utilisation"
  alarm_actions               = [aws_autoscaling_policy.wordpresspolicylow.arn]
}
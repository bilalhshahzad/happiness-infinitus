locals {
  applied_tags                      = merge(var.custom_tags, var.base_tags)
}

resource "aws_lb" "this" {  
  name                              = format("%s-%s", "wp-lb-", formatdate("YYYYMMDDhhmmss",timestamp()))
  subnets                           = [var.subnet_public-a_id, var.subnet_public-b_id]
  security_groups                   = [var.sg_web_id]
  internal                          = false
  load_balancer_type                = "application" 
  enable_cross_zone_load_balancing  = true
  idle_timeout                      = 400
  tags                              = local.applied_tags
}

resource "aws_lb_target_group" "this" {  
  name                              = format("%s-%s", "wp-tg-", formatdate("YYYYMMDDhhmmss",timestamp()))
  port                              = 80
  protocol                          = "HTTP"  
  vpc_id                            = var.vpc_id 
  tags                              = local.applied_tags
  
  stickiness {    
    type                            = "lb_cookie"    
  }   
  health_check {    
    healthy_threshold               = 2    
    unhealthy_threshold             = 2    
    timeout                         = 3    
    interval                        = 30    
    path                            = "/"    
    port                            = 80
  }
}

resource "aws_lb_listener" "this" {  
  load_balancer_arn                 = aws_lb.this.arn
  port                              = 80
  protocol                          = "HTTP"
  
  default_action {    
    target_group_arn                = aws_lb_target_group.this.arn
    type                            = "forward"  
  }
}
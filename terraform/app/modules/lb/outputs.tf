output "lb_wp_id" {
  description     = ""
  value           = aws_lb.this.id
}

output "lb_target_group_arn" {
  description     = ""
  value           = aws_lb_target_group.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}
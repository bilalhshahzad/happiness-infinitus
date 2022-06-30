output "rdshost" {
    description         = ""
    value               = module.wp_rds.rdshost
}
output "efsid" {
    description         = ""
    value               = module.wp_efs.efsid
}
output "sg_db_id" {
    description         = ""
    value               = module.wp_sg.sg_db_id
}
output "sg_web_id" {
    description         = ""
    value               = module.wp_sg.sg_web_id
}
output "sg_efs_id" {
    description         = ""
    value               = module.wp_sg.sg_efs_id
}
output "subnet_private-a_id" {
    description         = ""
    value               = module.wp_vpc.subnet_private-a_id
}
output "subnet_private-b_id" {
    description         = ""
    value               = module.wp_vpc.subnet_private-b_id
}
output "subnet_public-a_id" {
    description         = ""
    value               = module.wp_vpc.subnet_public-a_id
}
output "subnet_public-b_id" {
    description         = ""
    value               = module.wp_vpc.subnet_public-b_id
}
output "vpc_id" {
    description         = ""
    value               = module.wp_vpc.vpc_id
}
output "lb_wp_id" {
    description         = ""
    value               = module.wp_lb.lb_wp_id
}
output "alb_dns_name" {
    description         = ""
    value               = module.wp_lb.alb_dns_name
}
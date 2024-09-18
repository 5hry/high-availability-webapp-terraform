output "load_balancer_id" {
  value = aws_lb.my_alb.id
}

output "target_group_arn" {
  value = aws_lb_target_group.web_app_TG.arn
}

output "load_balancer_dns" {
  value = aws_lb.my_alb.dns_name
}
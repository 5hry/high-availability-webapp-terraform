output "alb_dns" {
  value = module.loadbalancer.load_balancer_dns
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}
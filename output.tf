output "alb_dns" {
  value = module.loadbalancer.load_balancer_dns
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}

output "bastion_IP" {
  description = "Bastion's Public IP address"
  value       = module.ec2.bastion_IP
}

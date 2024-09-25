module "vpc" {
  source = "./modules/vpc"

}

module "ec2" {
  source             = "./modules/ec2"
  vpc_id             = module.vpc.vpc_id
  private_subnets_id = module.vpc.private_subnets
  public_subnets_id  = module.vpc.public_subnets
  load_balancer_id   = module.loadbalancer.load_balancer_id
  target_group_arn   = module.loadbalancer.target_group_arn
}

module "loadbalancer" {
  source            = "./modules/load_balancer"
  public_subnets_id = module.vpc.public_subnets
  vpc_id            = module.vpc.vpc_id
  internet_gw       = module.vpc.internet_gw.id
  certificate_arn = module.route53.cert_arn
}

module "database" {
  source                  = "./modules/rds"
  vpc_id                  = module.vpc.vpc_id
  database_subnets        = module.vpc.database_subnets
  private_security_groups = module.ec2.private_security_groups
}

module "route53" {
  source       = "./modules/route53"
  alb_dns_name = module.loadbalancer.load_balancer_dns
}

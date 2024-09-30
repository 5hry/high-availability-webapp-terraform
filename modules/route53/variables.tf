variable "alb_dns_name" {
  type = string
}

variable "domain_name" {
  type = string
  default = "akaisme.click"
}

variable "fully_domain_name" {
  type = string
  default = "workshop2.akaisme.click"
}

variable "db" {
  type = string
  default = "db.akaisme.click"
}

variable "endpoint" {
  type = string
}
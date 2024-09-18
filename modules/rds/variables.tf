variable "database_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}


variable "private_security_groups" {
  type = list(string)
}
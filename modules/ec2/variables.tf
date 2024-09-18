variable "instance_type" {
  type        = string
  description = "Instance Type"
  default     = "t2.micro"
}

variable "ami_name" {
  type        = string
  description = "AMI name"
  default     = "ami-04a5ce820a419d6da"
}

variable "key_name" {
  type        = string
  description = "Key pair name"
  default     = "sgkeypair"
}

variable "private_subnets_id" {
  description = "List of private app subnets"
  type        = list(string)  # Assuming it's a list of subnets
}

variable "public_subnets_id" {
  description = "List of public app subnets"
  type        = list(string)  # Assuming it's a list of subnets
}

variable "vpc_id" {
  type = string
}

variable "load_balancer_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}
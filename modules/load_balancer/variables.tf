variable "vpc_id" {
  type = string
}

variable "public_subnets_id" {
  description = "List of private app subnets"
  type        = list(string)  # Assuming it's a list of subnets
}

variable "internet_gw" {
  type = string
}
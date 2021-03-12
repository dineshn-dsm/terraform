variable "aws_region" {
  type = string
}

variable "vpc_cidr_block" {}


variable "subnet_cidrs_public" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  type = "list"
}

variable "vpc_tags" {
  type = string
}
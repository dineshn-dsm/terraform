variable "instance_type" {
  type = string
}

variable "tags" {
  type = string
}

variable instance_count {
  description = "Number of EC2 instances to deploy"
  type        = number
}

variable "ami_data_filter" {
  description = "Desired name of AWS AMI to data source"
  type = list
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  type = string
}

variable "ec2_security_groups" {
  type = list
}

variable "subnet_id" {
  type = list
}
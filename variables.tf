variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_data_filter" {
  description = "Desired name of AWS AMI to data source"
  type = list
  default = ["amzn2-ami-hvm-2.0.20201218.1-x86_64-gp2"]
}

variable "key_pair_name" {
  type    = string
  default = "<Key_name>"
}

variable "no_of_instance" {
  description = "Desired no of instance, minimum 2"
  type    = number
  default = "2"
}

variable "alb_listener_port" {
  type    = number
  default = "80"
}

variable "alb_listener_protocol" {
  type    = string
  default = "HTTP"
}

variable "alb_listener_path" {
  type    = string
  default = "/"
}
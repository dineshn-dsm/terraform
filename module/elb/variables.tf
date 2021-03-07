variable "lb_tags" {
  type = string
}

variable "alb_listener_port" {
  type = number
}


variable "alb_listener_protocol" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "lb_security_groups" {
  type = list
}

variable "instance_id" {
}


variable "subnet_id" {
  type = list
}

variable "alb_listener_path" {
  type = string
}

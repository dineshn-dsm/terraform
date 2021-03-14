variable "asg_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "shutdown_behaviour" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "asg_security_groups" {
  type = list
}

variable "tags" {
  type = string
}

variable "update_default_version" {
  type = bool
}

variable "desired_capacity" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "target_cpu_percent" {
  type = number
}

variable "user_data_base64" {
  type = string
}


variable "subnet_id" {
  type = list
}

variable "asg_listener_port" {
  type = number
}

variable "asg_listener_protocol" {
  type = string
}

variable "asg_listener_path" {
  type = string
}

variable "vpc_id" {
  type = string
}

/*
# to be used when mounting addtional volume
variable "ebs_volume_name_2" {
  type = string
}

variable "ebs_volume_size_2" {
  type = number
}

*/
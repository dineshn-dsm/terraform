provider "aws" {
  region  = var.aws_region
}

data "aws_vpc" "default" {
  default = true
} 

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id 
} 

module "ec2" {
  source                  = "./module/ec2"
  instance_type           = var.instance_type
  ami_data_filter         = var.ami_data_filter
  tags                    = "ec2-module"
  key_name                = var.key_pair_name
  instance_count          = var.no_of_instance
  ec2_security_groups     = ["${aws_security_group.allow_http.id}"]
  subnet_id               = data.aws_subnet_ids.default.ids
}

module "elb" {
  source                  = "./module/elb"
  lb_tags                 = "lb-module"
  alb_listener_port       = var.alb_listener_port
  alb_listener_protocol   = var.alb_listener_protocol
  alb_listener_path       = var.alb_listener_path
  vpc_id                  = data.aws_vpc.default.id 
  lb_security_groups      = ["${aws_security_group.allow_http.id}"]
  instance_id             = "${module.ec2.mpo_ec2_id}"  
  subnet_id               = data.aws_subnet_ids.default.ids
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http_ssh"
  description = "Allow http and ssh inbound traffic"
  

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}


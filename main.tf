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

module "s3" {
  source                  = "./module/s3"
  s3_tags                 = "s3-module" 
  s3_bucket_name          = var.s3_bucket_name
}

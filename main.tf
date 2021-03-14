provider "aws" {
  region  = var.aws_region
}

data "aws_vpc" "default" {
  default = true
} 

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id 
} 

module "vpc" {
  source                  = "./module/vpc"
  aws_region              = var.aws_region
  vpc_cidr_block          = "10.2.0.0/16"
  subnet_cidrs_public     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  vpc_tags                = "vpc-module" 
}

module "ec2" {
  source                  = "./module/ec2"
  instance_type           = var.instance_type
  ami_data_filter         = var.ami_data_filter
  tags                    = "ec2-module"
  key_name                = <key-pair-name>
  instance_count          = "2"
  ec2_security_groups     = ["${aws_security_group.allow_http.id}"]
  subnet_id               = "${module.vpc.mop_subnet_id}"  #data.aws_subnet_ids.default.ids
}

module "elb" {
  source                  = "./module/elb"
  lb_tags                 = "lb-module"
  alb_listener_port       = "80"
  alb_listener_protocol   = "HTTP"
  alb_listener_path       = "/"
  vpc_id                  = "${module.vpc.mop_vpc_id}"  #data.aws_vpc.default.id 
  lb_security_groups      = ["${aws_security_group.allow_http.id}"]
  instance_id             = "${module.ec2.mpo_ec2_id}"  
  subnet_id               = "${module.vpc.mop_subnet_id}" #data.aws_subnet_ids.default.ids
}

module "s3" {
  source                  = "./module/s3"
  s3_tags                 = "s3-module" 
  s3_bucket_name          = var.s3_bucket_name
}


module "asg" {
  source                  = "./module/autoscale"
  instance_type           = var.instance_type
  ami_id                  = data.aws_ami.amazon.id
  tags                    = "asg-module"
  key_name                = <key-pair-name>
  asg_name                = "asg-test"
  asg_security_groups     = ["${aws_security_group.allow_http.id}"]
  #ebs_volume_size_2       = "8" #gb , update if need to map additional drive
  #ebs_volume_name_2       = "/dev/sdb1" update if need to map additional drive
  shutdown_behaviour      = "terminate" # stop or terminate
  update_default_version  = true
  desired_capacity        = 1
  max_size                = 2
  min_size                = 1
  target_cpu_percent      = 50  #percentage
  vpc_id                  = "${module.vpc.mop_vpc_id}" 
  subnet_id               = "${module.vpc.mop_subnet_id}"
  asg_listener_port       = 80
  asg_listener_protocol   = "HTTP"
  asg_listener_path       = "/"
  user_data_base64        = "IyEvYmluL2Jhc2gKc3VkbyBzdQp5dW0gaW5zdGFsbCAteSBodHRwZC54ODZfNjQKc3lzdGVtY3RsIHN0YXJ0IGh0dHBkLnNlcnZpY2UKc3lzdGVtY3RsIGVuYWJsZSBodHRwZC5zZXJ2aWNlCmVjaG8gIkhlbGxvIFdvcmxkIGZyb20gJChob3N0bmFtZSAtZikiID4gL3Zhci93d3cvaHRtbC9pbmRleC5odG1s"
}

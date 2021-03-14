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


variable "s3_bucket_name" {
  type = string
}
# AWS EC2 Instance Terraform module

Terraform  which creates EC2 instance(s) with Nginx and Application Load balancer(public facing in HTTP) on AWS.

These types of resources are supported:

* [EC2 instance](https://www.terraform.io/docs/providers/aws/r/instance.html)

## Terraform versions

Terraform v0.14.5

## Usage

udpate below details in `variables.tf` eg: key_pari_name, no_of_instance, region, ami data filter

```hcl
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
```


## security group update

Currently SSH & HTTP is allowed to `any where`, update required ip in  `cidr_blocks` ingress 

```hcl
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
```


## Notes


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 2.65 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.65 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami_data_filter | Name AMI to use in data source filter | `string` | amazon 2 ami | yes |
| instance_type | Instance type | `string` | t2.micro | yes |
| aws_region | aws region to deploy | `string` | ap-south-1 | no |
| key_pair_name | Kay pair to bind | `string` | n/a | yes |
| no_of_instance | Desired no of instance, minimum 2 | `number` | `2` | no |


## Outputs

1. sInstance public ips
2. ALB DNS

## Authors

Module managed by [Dinesh N](https://github.com/dineshn-dsm).


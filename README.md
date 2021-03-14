# Launch AWS services using Terraform 

Terraform which creates below services on AWS
* New VPC with public subnet
* Deploy EC2 instance(s) with Nginx and Application Load balancer(public facing in HTTP) on new VPC
* S3 bucket with public read access to S3 dns
* Auto scalling group using Launch template which deploys Apache on EC2 instance and expose in ALB.

These types of resources are supported:

* [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
* [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
* [EC2 instance](https://www.terraform.io/docs/providers/aws/r/instance.html)
* [Load Balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)
* [Auto scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)

## Terraform versions

Terraform v0.14.5

## Usage

Install terraform --> clone this repo --> update  required input values --> Run below commands

terraform init
terraform plan
terraform apply --auto-approve

## Changes required

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
```

udpate VPC below details in `main.tf` eg: VPC CIDR ip range & subnet ip range

```hcl
  vpc_cidr_block          = "10.2.0.0/16"
  subnet_cidrs_public     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]

```

udpate EC2 below details in `main.tf` eg: key_piar_name, instance count

```hcl
  key_name                = <key-pair-name>
  instance_count          = "2"

```

udpate elb below details in `main.tf` eg: alb listener port, protocol, peath

```hcl
  alb_listener_port       = "80"
  alb_listener_protocol   = "HTTP"
  alb_listener_path       = "/"
  
```

udpate asg below details in `main.tf` eg: key_piar name, instance max/min/desired count, etc

```hcl
  key_name                = <key-pair-name>
  shutdown_behaviour      = "terminate" # stop or terminate
  desired_capacity        = 1
  max_size                = 2
  min_size                = 1
  target_cpu_percent      = 50  #percentage
  asg_listener_port       = 80
  asg_listener_protocol   = "HTTP"
  asg_listener_path       = "/"
  
```


## security group update

Currently SSH & HTTP is allowed to `any where`, update required ip in  `cidr_blocks` ingress in `sg.tf` file

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

This Terraform scripts create all resources mentioned above. Please comment module which dont need to be executed.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |


## Modules

No external Modules.

## Resources

| Name |
|------|
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | aws region to deploy | `string` | ap-south-1 | no |
| vpc_cidr_block | VPC CIDR block range | n/a | 10.2.0.0/16 | yes |
| subnet_cidrs_public | Public subnet CIDR block range | `list` | "10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24" | yes |
| ami_data_filter | Name AMI to use in data source filter | `string` | amazon 2 ami | yes |
| instance_type | Instance type | `string` | t2.micro | yes |
| key_pair_name | Kay pair to bind | `string` | n/a | yes |
| no_of_instance | Desired no of instance, minimum 2 | `number` | `2` | no |
| s3_bucket_name | Unique Name of bucket to host static website | `Unique name` | `n/a | yes |
| desired_capacity | Auto scalling group desired instance count | `number` | 1 | No |
| max_size |  Auto scalling group maximum instance count | `number` | 2 | No |
| min_size |  Auto scalling group minimum instance count | `number` | 1 | No |
| target_cpu_percent | Auto scale policy cpu percentage| `number in %` | 50 | yes |
| user_data_base64 | The Base64-encoded user data to provide when launching the instance. | `Base64-encoded` | httpd | yes |


## Outputs

1. Instance public ips
2. ALB DNS
3. S3 Bucket website DNS

## Author

Module managed by [Dinesh N](https://github.com/dineshn-dsm).


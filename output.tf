output "ec2_ip" {
  description = "ip of the instance"
  value       = module.ec2.mpo_ec2_ip
}

output "lb_dns" {
  description = "DNS name for the Load balancer"
  value       = module.elb.lb_pub_ip
}

output "s3_dns" {
  description = "DNS name for the S3 bucket"
  value       = module.s3.mop_s3_dns
}
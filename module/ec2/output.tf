output "mpo_ec2_ip" {
  description = "ip of the instance"
  value       = aws_instance.web
}

output "mpo_ec2_id" {
  description = "id of the instances"
  value       = aws_instance.web.*.id
}




output "mop_vpc_id" {
  description = "id of the vpc"
  value       = aws_vpc.test-vpc.id
}

output "mop_subnet_id" {
  description = "id of the subnets"
  value       = aws_subnet.test-subnet-public.*.id
}

output "lb_pub_ip" {
  description = "ip of the instance"
  value       = aws_lb.test.dns_name
}
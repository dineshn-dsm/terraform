output "mop_s3_dns" {
  description = "dns of the bucket"
  value       = aws_s3_bucket.website_bucket.website_endpoint
}
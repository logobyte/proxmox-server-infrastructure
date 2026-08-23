output "instance_id" {
  description = "ID of the EC2 portfolio demo instance."
  value       = aws_instance.portfolio_demo.id
}

output "instance_state" {
  description = "Current EC2 instance state."
  value       = aws_instance.portfolio_demo.instance_state
}

output "public_ip" {
  description = "Public IPv4 address, when one is assigned."
  value       = aws_instance.portfolio_demo.public_ip
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "ec2instance_ip" {
  value = aws_instance.ec2instance.public_ip
}

output "ec2instance_dns" {
  value = aws_instance.ec2instance.public_dns
}


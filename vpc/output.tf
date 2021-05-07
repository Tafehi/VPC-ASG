# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.app_server.public_ip
# }
output "aws_security_group" {
  value = aws_security_group.allow-HTTPS-sg
}

output "aws_subnets_public" {
  value = aws_subnet.public_subnet.*.id
}


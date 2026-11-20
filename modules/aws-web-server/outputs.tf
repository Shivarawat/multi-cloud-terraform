output "public_ip" {
  value = aws_instance.this.public_ip
}

output "ssh_command" {
  value = "ssh -i <your-private-key> ec2-user@${aws_instance.this.public_ip}"
}

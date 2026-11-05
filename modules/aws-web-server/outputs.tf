output "public_ip" {
  value = aws_instance.this.public_ip
}

output "ssh_command" {
  value = "ssh -i ${trimsuffix(pathexpand(var.public_key_path), ".pub")} ec2-user@${aws_instance.this.public_ip}"
}

output "public_ip" {
  value = module.web_server.public_ip
}

output "ssh_command" {
  value = module.web_server.ssh_command
}

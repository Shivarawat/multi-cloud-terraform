data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_key_pair" "laptop" {
  key_name   = "day1-laptop"
  public_key = file(pathexpand("~/.ssh/day1_key.pub"))
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.laptop.key_name

  user_data = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>Hello from Terraform - Shiv</h1>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT

  tags = {
    Name      = "day1-web"
    ManagedBy = "terraform"
  }
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/day1_key ec2-user@${aws_instance.web.public_ip}"
}

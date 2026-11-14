module "network" {
  source = "../../modules/aws-network"

  name     = "dev"
  vpc_cidr = "10.10.0.0/16"
  public_subnets = {
    "ap-south-1a" = "10.10.1.0/24"
    "ap-south-1b" = "10.10.2.0/24"
  }
}

module "web_server" {
  source = "../../modules/aws-web-server"

  name            = "dev"
  vpc_id          = module.network.vpc_id
  subnet_id       = module.network.public_subnet_ids[0]
  ssh_cidr        = var.ssh_cidr
  public_key_path = "~/.ssh/day1_key.pub"

  user_data = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>dev environment - built from modules</h1>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT
}

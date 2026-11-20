module "network" {
  source = "../../modules/aws-network"

  name     = "prod"
  vpc_cidr = "10.20.0.0/16"
  public_subnets = {
    "ap-south-1a" = "10.20.1.0/24"
    "ap-south-1b" = "10.20.2.0/24"
    "ap-south-1c" = "10.20.3.0/24"
  }
}

module "web_server" {
  source = "../../modules/aws-web-server"

  name           = "prod"
  vpc_id         = module.network.vpc_id
  subnet_id      = module.network.public_subnet_ids[0]
  instance_type  = "t3.small"
  root_volume_gb = 16
  ssh_cidr       = var.ssh_cidr
  ssh_public_key = var.ssh_public_key

  user_data = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>prod environment - built from modules</h1>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT
}

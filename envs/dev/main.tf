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

  name           = "dev"
  vpc_id         = module.network.vpc_id
  subnet_id      = module.network.public_subnet_ids[0]
  ssh_cidr       = var.ssh_cidr
  ssh_public_key = var.ssh_public_key

  instance_type       = "t3.small"
  root_volume_gb      = 20
  extra_ingress_ports = [3000]

  user_data = templatefile("${path.module}/../../scripts/notification-pipeline.sh", {
    repo_url        = "https://github.com/Shivarawat/notification-pipeline.git"
    git_ref         = "main"
    compose_version = "v2.29.7"
    buildx_version  = "v0.17.1"
  })
}

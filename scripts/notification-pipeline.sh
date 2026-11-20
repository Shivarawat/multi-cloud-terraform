#!/bin/bash
# First-boot script: installs Docker and runs the Notification Pipeline with Docker Compose.
set -euxo pipefail

# 1 GB swap so Kafka + Zookeeper + Postgres + Redis + 2 Node services fit in memory
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

dnf install -y docker git
systemctl enable --now docker

# Docker Compose v2 and buildx plugins
mkdir -p /usr/local/lib/docker/cli-plugins
curl -fsSL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-x86_64" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
curl -fsSL "https://github.com/docker/buildx/releases/download/${buildx_version}/buildx-${buildx_version}.linux-amd64" \
  -o /usr/local/lib/docker/cli-plugins/docker-buildx
chmod +x /usr/local/lib/docker/cli-plugins/*

git clone --depth 1 --branch ${git_ref} ${repo_url} /opt/notification-pipeline
cd /opt/notification-pipeline
docker compose up -d --build

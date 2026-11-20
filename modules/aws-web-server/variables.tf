variable "name" {
  description = "Prefix for resource names, e.g. dev or prod"
  type        = string
}

variable "vpc_id" {
  description = "VPC to create the security group in"
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch the instance in"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH in"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key contents (e.g. ssh-ed25519 AAAA...)"
  type        = string
}

variable "extra_ingress_ports" {
  description = "Extra TCP ports to open to the internet, e.g. [3000] for an app"
  type        = list(number)
  default     = []
}

variable "user_data" {
  description = "Script to run on first boot"
  type        = string
  default     = ""
}

variable "root_volume_gb" {
  description = "Root disk size in GB"
  type        = number
  default     = 8
}

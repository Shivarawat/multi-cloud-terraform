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

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "user_data" {
  description = "Script to run on first boot"
  type        = string
  default     = ""
}

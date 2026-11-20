variable "ssh_cidr" {
  description = "Your SSH source IP as a CIDR, e.g. 1.2.3.4/32"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key contents"
  type        = string
}

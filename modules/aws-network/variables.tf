variable "name" {
  description = "Prefix for resource names, e.g. dev or prod"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Map of availability zone to subnet CIDR"
  type        = map(string)
}

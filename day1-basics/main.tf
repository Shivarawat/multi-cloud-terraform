terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "first" {
  bucket = "shiv-tf-day1-293033346095"

  tags = {
    Project   = "multi-cloud-terraform"
    ManagedBy = "terraform"
    Owner = "shiv"
  }
}

output "bucket_arn" {
  value = aws_s3_bucket.first.arn
}

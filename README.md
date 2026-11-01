# multi-cloud-terraform

Infrastructure as Code on AWS, Azure and GCP with Terraform.

## day1-basics (AWS, ap-south-1)

| File | What it creates |
|---|---|
| `main.tf` | AWS provider, an S3 bucket with tags |
| `network.tf` | VPC `10.0.0.0/16`, public subnet `10.0.1.0/24`, Internet Gateway, route table + association |
| `security.tf` | Security group: SSH from a single CIDR (`var.my_ip`), HTTP from anywhere |
| `compute.tf` | Latest Amazon Linux 2023 AMI (data source), key pair, `t3.micro` running nginx via `user_data` |

```bash
cd day1-basics
echo 'my_ip = "<your-ip>/32"' > terraform.tfvars
terraform init && terraform plan && terraform apply
terraform destroy
```

State, `.tfvars` and keys are git-ignored.

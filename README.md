# multi-cloud-terraform

Infrastructure as Code with Terraform: reusable modules, remote state with locking, and per-environment configs. AWS today, with Azure and GCP next.

## Layout

```
bootstrap/              S3 state bucket (versioning, encryption, public access blocked, prevent_destroy)
modules/
  aws-network/          VPC, public subnets per AZ (for_each), Internet Gateway, route table
  aws-web-server/       Security group, key pair, EC2 (Amazon Linux 2023, IMDSv2 enforced)
envs/
  dev/                  Uses both modules; state in S3 with native locking (use_lockfile)
day1-basics/            First single-folder version (S3, VPC, SG, EC2 + nginx)
```

## Usage

```bash
# 1. One-time: create the state bucket (local state)
cd bootstrap && terraform init && terraform apply

# 2. An environment (remote state in S3)
cd ../envs/dev
echo 'ssh_cidr = "<your-ip>/32"' > terraform.tfvars
terraform init && terraform plan && terraform apply
terraform destroy
```

## Design notes

- **Remote state:** one bucket, one key per environment (`envs/dev/terraform.tfstate`), with S3-native lock files so concurrent applies can't corrupt state.
- **Modules** take inputs and return outputs; `envs/dev` wires `module.network.vpc_id` into the web-server module.
- **for_each over count** for subnets, so removing one AZ doesn't recreate the others.
- **Security:** SSH limited to a single /32, IMDSv2 required, state encrypted, and no secrets, state or `.tfvars` in git.
- **default_tags** on the provider tag every resource with Environment / ManagedBy / Project.

# multi-cloud-terraform

AWS infrastructure as code with Terraform: reusable modules, dev/prod environments, S3 remote state with locking, and a GitHub Actions pipeline that authenticates to AWS with OIDC (no stored keys).

## Layout

```
bootstrap/              S3 state bucket + GitHub OIDC provider and plan/apply IAM roles
modules/
  aws-network/          VPC, public subnets per AZ (for_each), Internet Gateway, route table
  aws-web-server/       Security group, key pair, EC2 (Amazon Linux 2023, IMDSv2 enforced)
envs/
  dev/                  2 AZs, t3.small running the Notification Pipeline (Docker Compose via user_data)
  prod/                 3 AZs, t3.small, separate state key and CIDR
scripts/                First-boot script templates
.github/workflows/      fmt, validate, tflint, checkov, plan-as-PR-comment; approval-gated apply/destroy
day1-basics/            First single-folder version (S3, VPC, SG, EC2 + nginx)
```

## Usage

```bash
# 1. One-time: create the state bucket (local state)
cd bootstrap && terraform init && terraform apply

# 2. An environment (remote state in S3)
cd ../envs/dev
printf 'ssh_cidr = "<your-ip>/32"\nssh_public_key = "<public key>"\n' > terraform.tfvars
terraform init && terraform plan && terraform apply
terraform destroy
```

## Design notes

- **Remote state:** one bucket, one key per environment (`envs/dev/terraform.tfstate`), with S3-native lock files so concurrent applies can't corrupt state.
- **Modules** take inputs and return outputs; `envs/dev` wires `module.network.vpc_id` into the web-server module.
- **for_each over count** for subnets, so removing one AZ doesn't recreate the others.
- **Security:** SSH limited to a single /32, IMDSv2 required, state encrypted, and no secrets, state or `.tfvars` in git.
- **default_tags** on the provider tag every resource with Environment / ManagedBy / Project.
- **CI/CD:** PRs get format, validate, lint and Checkov checks, and the plan for each env is posted as a PR comment using a read-only role. Apply/destroy is a manual run gated by GitHub environment approval, using a separate apply role. Both roles are assumed via OIDC with trust pinned to this repo.
- **Hardening:** IMDSv2 required, encrypted gp3 root volumes, SSH restricted to one /32.

## CI status

Pull requests run checks and post a Terraform plan for dev and prod.

# AWS Automation Portfolio

A small portfolio repository demonstrating AWS automation using:

- Bash
- AWS CLI
- Amazon EC2
- Amazon S3
- Terraform
- AWS CloudFormation
- GitHub Actions
- Git / GitHub

## Safety-first design

This repository intentionally does **not** contain:

- AWS access keys
- AWS secret access keys
- passwords
- private SSH keys
- real account IDs
- real production resource IDs
- Terraform state files
- `.tfvars` files containing secrets

Use IAM roles, AWS SSO, GitHub OIDC, or locally configured AWS CLI credentials instead.

## Project Structure

```text
aws-automation-portfolio/
├── ec2/
│   ├── start.sh
│   ├── stop.sh
│   └── monitor.sh
├── s3/
│   ├── backup.sh
│   └── sync.sh
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── cloudformation/
│   └── ec2.yaml
├── .github/
│   └── workflows/
│       └── validate.yml
├── .env.example
├── .gitignore
├── LICENSE
└── README.md
```

## Prerequisites

Install:

- AWS CLI v2
- Terraform
- Git

Verify:

```bash
aws --version
terraform version
git --version
```

Configure AWS access safely with one of these approaches:

```bash
aws configure sso
```

or:

```bash
aws configure
```

For real projects, prefer short-lived credentials, IAM roles, or AWS SSO instead of long-lived access keys.

## Environment Variables

Copy the example file:

```bash
cp .env.example .env
```

Edit `.env` locally and provide non-sensitive resource identifiers.

You can also export variables directly:

```bash
export AWS_REGION=ap-southeast-1
export EC2_INSTANCE_ID=i-xxxxxxxxxxxxxxxxx
export S3_BUCKET_NAME=my-demo-bucket
```

## EC2 Automation

### Start an instance

```bash
./ec2/start.sh
```

The script checks the current instance state first and only attempts to start an instance that is stopped.

### Stop an instance

```bash
./ec2/stop.sh
```

For safety, stopping requires explicit confirmation through:

```bash
CONFIRM_STOP=yes ./ec2/stop.sh
```

### Monitor an instance

```bash
./ec2/monitor.sh
```

This only reads EC2 instance information.

## S3 Automation

### Backup a local directory

```bash
./s3/backup.sh
```

This uploads files using `aws s3 sync`.

### Preview an S3 sync

```bash
./s3/sync.sh
```

By default, this script uses `--dryrun`.

To perform the actual sync:

```bash
APPLY_SYNC=yes ./s3/sync.sh
```

## Terraform

The Terraform example creates a minimal EC2 instance using variables.

Initialize and validate:

```bash
cd terraform
terraform init
terraform fmt -check
terraform validate
```

Preview changes:

```bash
terraform plan \
  -var="ami_id=ami-xxxxxxxxxxxxxxxxx" \
  -var="instance_type=t3.micro"
```

The repository intentionally does not auto-run `terraform apply`.

## CloudFormation

Validate the template:

```bash
aws cloudformation validate-template \
  --template-body file://cloudformation/ec2.yaml
```

Deployment is deliberately left as a manual action.

## GitHub Actions

The included workflow performs static validation only:

- Shell syntax checks
- Terraform formatting / validation
- CloudFormation YAML syntax check

It does **not** deploy infrastructure.

## Recommended IAM Practice

For a portfolio repository:

1. Never commit AWS credentials.
2. Use a dedicated sandbox AWS account when possible.
3. Grant least-privilege permissions.
4. Use GitHub OIDC instead of storing long-lived AWS keys in GitHub Secrets.
5. Add billing alerts before creating resources.
6. Destroy temporary resources after testing.
7. Never place Terraform state containing sensitive values in a public repository.

## Suggested Portfolio Enhancements

Good next additions:

- GitHub OIDC authentication
- CloudWatch monitoring scripts
- Lambda automation examples
- SNS notifications
- Terraform modules
- AWS Budgets / cost alerts
- Automated tests with ShellCheck
- Architecture diagram

## Disclaimer

This repository is intended for learning and portfolio demonstration. Review AWS pricing and permissions before creating resources in your AWS account.

---

# Homelab and Laravel Deployment

This portfolio now also includes a virtualization and Linux deployment lab.

## Added Topics

- Proxmox VE VM setup
- Ubuntu Server installation and configuration
- QEMU Guest Agent
- SSH key authentication
- UFW firewall
- Ubuntu bootstrap automation
- Nginx
- PHP-FPM
- MySQL
- Laravel server setup
- Laravel deployment workflow
- Laravel queue worker
- Laravel scheduler
- DevOps portfolio roadmap

## Guides

Start here:

```text
docs/PROXMOX_VM_SETUP.md
docs/UBUNTU_SETUP.md
docs/LARAVEL_DEPLOYMENT.md
docs/PORTFOLIO_ROADMAP.md
```

## Helper Scripts

```text
ubuntu/bootstrap.sh
laravel/install-stack.sh
laravel/deploy-example.sh
```

The scripts intentionally avoid automatically changing dangerous settings such as disabling SSH passwords, enabling a firewall before access is verified, or installing Composer without current installer verification.

# proxmox-server-infrastructure

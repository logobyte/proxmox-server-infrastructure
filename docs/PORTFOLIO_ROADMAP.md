# DevOps / Cloud Portfolio Roadmap

This repository can be developed in phases.

## Phase 1 - Linux and Virtualization

- Proxmox VE lab
- Ubuntu Server VM
- Linux administration
- SSH keys
- Firewall
- Git

## Phase 2 - Laravel Hosting

- Nginx
- PHP-FPM
- MySQL
- Composer
- Laravel deployment
- Queue workers
- Scheduler

## Phase 3 - Containers

- Docker
- Docker Compose
- Laravel containerization
- Nginx container
- MySQL container

## Phase 4 - AWS Automation

- EC2 automation
- S3 automation
- CloudWatch
- SNS
- IAM
- Lambda

## Phase 5 - Infrastructure as Code

- Terraform
- CloudFormation
- reusable Terraform modules

## Phase 6 - CI/CD

- GitHub Actions
- tests
- static analysis
- artifact builds
- GitHub OIDC for AWS
- deployment workflow

## Phase 7 - Observability

- CloudWatch
- application logs
- server metrics
- uptime monitoring
- alerting

## Suggested Portfolio Diagram

```text
                        GitHub
                          |
                    GitHub Actions
                          |
             +------------+-------------+
             |                          |
          Homelab                      AWS
             |                          |
          Proxmox                 Terraform / CFN
             |                          |
        Ubuntu Server                  EC2
             |                          |
      Nginx + PHP-FPM             CloudWatch
             |                          |
          Laravel -------------------- S3
             |
           MySQL
```

# Infrastructure as Code - Linux Server Configurations

A comprehensive Infrastructure as Code (IaC) repository for automating the deployment and configuration of Linux servers across multiple distributions and cloud platforms.

## Supported Linux Distributions

### Debian-based
- **Ubuntu** (20.04 LTS, 22.04 LTS, 24.04 LTS)
- **Debian** (11 Bullseye, 12 Bookworm)
- **Linux Mint** (21.x)

### Red Hat-based
- **CentOS** (Stream 8, Stream 9)
- **Rocky Linux** (8.x, 9.x)
- **AlmaLinux** (8.x, 9.x)
- **Red Hat Enterprise Linux** (8.x, 9.x)
- **Fedora** (38, 39, 40)

### Alpine-based
- **Alpine Linux** (3.18, 3.19, 3.20)

### SUSE-based
- **openSUSE Leap** (15.4, 15.5)
- **SUSE Linux Enterprise Server** (15 SP4, 15 SP5)

### Arch-based
- **Arch Linux**
- **Manjaro**

### Other Distributions
- **Amazon Linux** (2, 2023)
- **Oracle Linux** (8.x, 9.x)

## Repository Structure

```
├── ansible/                 # TODO: Ansible playbooks and roles
│   ├── playbooks/
│   ├── roles/
│   ├── inventory/
│   └── group_vars/
├── terraform/              # Terraform configurations
│   ├── aws/
│   ├── azure/
│   ├── gcp/
│   └── modules/
├── packer/                 # Packer templates for custom images
│   ├── ubuntu/
│   ├── debian/
│   ├── alpine/
│   └── centos/
├── docker/                 # Dockerfiles and compose files
│   ├── base-images/
│   └── applications/
├── kubernetes/             # Kubernetes manifests
│   ├── deployments/
│   ├── services/
│   └── helm-charts/
├── scripts/                # Utility scripts
│   ├── bootstrap/
│   ├── monitoring/
│   └── backup/
├── docs/                   # Documentation
└── tests/                  # Testing configurations
```

## Prerequisites

### Required Tools
- **Terraform** >= 1.5.0
- **Ansible** >= 2.15.0
- **Packer** >= 1.9.0
- **Docker** >= 24.0.0
- **kubectl** >= 1.28.0 (for Kubernetes deployments)

### Cloud Provider CLI Tools
- **AWS CLI** v2
- **Azure CLI**
- **Google Cloud SDK**

### Authentication Setup
Ensure you have configured authentication for your target cloud providers:

```bash
# AWS
aws configure

# Azure
az login

# Google Cloud
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/your-org/iac-linux-configs.git
cd iac-linux-configs
```

### 2. Configure Variables
Copy and customize the configuration files:

```bash
# Terraform
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

# Ansible
cp ansible/group_vars/all.yml.example ansible/group_vars/all.yml
```

### 3. Deploy Infrastructure

#### Using Terraform (Cloud Infrastructure)
```bash
cd terraform/aws  # or azure/gcp
terraform init
terraform plan
terraform apply
```

#### Using Ansible (Server Configuration)
```bash
cd ansible
ansible-playbook -i inventory/production playbooks/site.yml
```

## Configuration Examples

### Basic Web Server (Ubuntu)
```yaml
# ansible/group_vars/webservers.yml
nginx_enabled: true
ssl_enabled: true
firewall_rules:
  - { port: 80, protocol: tcp }
  - { port: 443, protocol: tcp }
  - { port: 22, protocol: tcp }

packages:
  - nginx
  - certbot
  - python3-certbot-nginx
```

### Database Server (CentOS/Rocky)
```yaml
# ansible/group_vars/databases.yml
mysql_enabled: true
mysql_root_password: "{{ vault_mysql_root_password }}"
mysql_databases:
  - name: app_production
  - name: app_staging

firewall_rules:
  - { port: 3306, protocol: tcp, source: "10.0.0.0/8" }
```

### Container Host (Alpine)
```yaml
# ansible/group_vars/containers.yml
docker_enabled: true
docker_compose_enabled: true
docker_users:
  - app
  - deploy

packages:
  - docker
  - docker-compose
  - git
```

## Distribution-Specific Configurations

### Ubuntu/Debian
- Package management via `apt`
- SystemD service management
- UFW firewall configuration
- Automatic security updates

### CentOS/Rocky/AlmaLinux
- Package management via `dnf/yum`
- SystemD service management
- FirewallD configuration
- SELinux policy management

### Alpine Linux
- Package management via `apk`
- OpenRC service management
- Lightweight containerized deployments
- Security-focused minimal installations

### Amazon Linux
- AWS-optimized configurations
- CloudWatch agent setup
- SSM agent configuration
- AWS CLI pre-installed

## Security Hardening

All configurations include security hardening based on:
- **CIS Benchmarks**
- **NIST Cybersecurity Framework**
- **OWASP Security Guidelines**

### Implemented Security Measures
- SSH key-only authentication
- Fail2ban intrusion prevention
- Automated security updates
- Firewall configuration
- User privilege management
- Log aggregation and monitoring
- File integrity monitoring

## Monitoring and Logging

### Integrated Monitoring Stack
- **Prometheus** - Metrics collection
- **Grafana** - Visualization
- **Alertmanager** - Alert routing
- **Node Exporter** - System metrics
- **ELK Stack** - Log aggregation (optional)

### Cloud-Native Monitoring
- **AWS CloudWatch**
- **Azure Monitor**
- **Google Cloud Monitoring**

## Testing

### Automated Testing
```bash
# Test Ansible playbooks
cd ansible
ansible-playbook --check playbooks/site.yml

# Test Terraform configurations
cd terraform
terraform validate
terraform plan

# Run integration tests
./scripts/test-runner.sh
```

### Supported Test Frameworks
- **Molecule** (Ansible testing)
- **Terratest** (Terraform testing)
- **InSpec** (Compliance testing)
- **Testinfra** (Infrastructure testing)

## Backup and Disaster Recovery

### Automated Backup Solutions
- Database backups with retention policies
- Configuration file backups
- System image snapshots
- Cross-region replication

### Recovery Procedures
- Documented recovery runbooks
- Automated restore scripts
- RTO/RPO compliance monitoring

## Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make changes and test locally
4. Submit a pull request
5. Code review and approval

### Coding Standards
- Follow Ansible best practices
- Use Terraform modules for reusability
- Document all variables and outputs
- Include examples for new configurations

## Environment Management

### Supported Environments
- **Development** - Single instance, basic configuration
- **Staging** - Production-like, reduced resources
- **Production** - Full redundancy, monitoring, backups

### Environment Promotion
```bash
# Promote staging to production
./scripts/promote-environment.sh staging production
```

## Troubleshooting

### Common Issues
- **SSH Connection Failures**: Check security groups and key pairs
- **Package Installation Errors**: Verify repository URLs and GPG keys
- **Service Start Failures**: Check service dependencies and configurations
- **Permission Denied**: Verify user privileges and sudo access

### Debug Mode
```bash
# Ansible verbose output
ansible-playbook -vvv playbooks/site.yml

# Terraform debug logging
export TF_LOG=DEBUG
terraform apply
```

## Support and Documentation

### Additional Resources
- [Ansible Documentation](docs/ansible/)
- [Terraform Modules](docs/terraform/)
- [Security Guidelines](docs/security/)
- [Troubleshooting Guide](docs/troubleshooting/)

### Getting Help
- Create an issue in the repository
- Check existing documentation
- Review example configurations
- Contact the infrastructure team

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

---

**Maintainers**: Infrastructure Team  
**Last Updated**: June 2025  
**Version**: 2.1.0
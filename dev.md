# Developer Environment Setup Guide

Complete guide for setting up development environments for Infrastructure as Code projects using virtualization platforms on Ubuntu/Debian systems.

## Table of Contents

1. [Virtualization Platforms](#virtualization-platforms)
2. [Base System Requirements](#base-system-requirements)
3. [Essential Tools Installation](#essential-tools-installation)
4. [Development Tools](#development-tools)
5. [Cloud Provider Tools](#cloud-provider-tools)
6. [Container and Orchestration Tools](#container-and-orchestration-tools)
7. [IDE and Editor Setup](#ide-and-editor-setup)
8. [Environment Configuration](#environment-configuration)
9. [Testing and Validation Tools](#testing-and-validation-tools)
10. [Troubleshooting](#troubleshooting)

## Virtualization Platforms

### Supported Platforms

#### Windows Subsystem for Linux (WSL2)
- **Best for**: Windows developers
- **Advantages**: Native Windows integration, excellent performance
- **Requirements**: Windows 10/11 with WSL2 enabled
- **Recommended**: Ubuntu 22.04 LTS or Debian 12

#### VirtualBox
- **Best for**: Cross-platform development, isolated environments
- **Advantages**: Free, snapshot support, multiple OS support
- **Requirements**: 8GB+ RAM, 50GB+ disk space
- **Recommended**: Ubuntu 22.04 LTS with Guest Additions

#### VMware Workstation/Fusion
- **Best for**: Professional development, performance-critical tasks
- **Advantages**: Better performance, advanced networking
- **Requirements**: 16GB+ RAM, SSD storage recommended

#### Cloud-based Development
- **Platforms**: AWS Cloud9, GitHub Codespaces, GitPod, Azure DevSpaces
- **Best for**: Team collaboration, consistent environments
- **Advantages**: No local resource constraints, pre-configured environments

## Base System Requirements

### Minimum Hardware Requirements
```
CPU: 4 cores (8 threads recommended)
RAM: 8GB (16GB+ recommended for containers)
Storage: 50GB free space (SSD recommended)
Network: Stable internet connection
```

### Ubuntu/Debian Base Installation
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential build tools
sudo apt install -y \
  build-essential \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  gnupg \
  lsb-release \
  curl \
  wget \
  git \
  vim \
  unzip \
  jq \
  tree \
  htop \
  net-tools \
  dnsutils
```

## Essential Tools Installation

### 1. Git Configuration
```bash
# Install Git (if not already installed)
sudo apt install -y git

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"
git config --global init.defaultBranch main
git config --global pull.rebase false

# Optional: Configure SSH keys for Git
ssh-keygen -t ed25519 -C "your.email@company.com"
```

### 2. Python and Package Management
```bash
# Install Python and pip
sudo apt install -y python3 python3-pip python3-venv python3-dev

# Install pipx for isolated Python applications
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Install Poetry for Python dependency management
pipx install poetry

# Install common Python packages
pip3 install --user \
  requests \
  pyyaml \
  jinja2 \
  netaddr \
  dnspython
```

### 3. Node.js and npm
```bash
# Install Node.js LTS via NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
node --version
npm --version

# Install global packages
npm install -g \
  yarn \
  @aws-cdk/cli \
  serverless \
  prettier \
  eslint
```

## Development Tools

### 1. Terraform
```bash
# Add HashiCorp GPG key and repository
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
sudo apt update && sudo apt install -y terraform

# Install Terraform version manager (tfenv) - Optional
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify installation
terraform version
```

### 2. Ansible
```bash
# Install Ansible via pip (recommended for latest version)
pipx install ansible

# Or install via apt (may be older version)
sudo apt install -y ansible

# Install Ansible collections
ansible-galaxy collection install \
  community.general \
  community.crypto \
  ansible.posix \
  community.docker \
  kubernetes.core

# Install additional Ansible tools
pipx install \
  ansible-lint \
  molecule \
  molecule-plugins[docker]

# Verify installation
ansible --version
ansible-lint --version
```

### 3. Packer
```bash
# Install Packer (from HashiCorp repository - already added above)
sudo apt install -y packer

# Verify installation
packer version
```

### 4. Vagrant (for VirtualBox/VMware development)
```bash
# Install Vagrant
sudo apt install -y vagrant

# Install common Vagrant plugins
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-disksize
vagrant plugin install vagrant-hostmanager

# Verify installation
vagrant version
```

## Cloud Provider Tools

### 1. AWS CLI and Tools
```bash
# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Install AWS Session Manager plugin
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
rm session-manager-plugin.deb

# Install eksctl for EKS management
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Verify installations
aws --version
eksctl version
```

### 2. Azure CLI
```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Verify installation
az --version
```

### 3. Google Cloud SDK
```bash
# Add Google Cloud SDK repository
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Install Google Cloud SDK
sudo apt update && sudo apt install -y google-cloud-cli

# Install additional components
sudo apt install -y \
  google-cloud-cli-gke-gcloud-auth-plugin \
  kubectl

# Verify installation
gcloud version
```

## Container and Orchestration Tools

### 1. Docker
```bash
# Remove old Docker versions
sudo apt remove -y docker docker-engine docker.io containerd runc

# Add Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Verify installation
docker --version
docker compose version
```

### 2. Kubernetes Tools
```bash
# kubectl is already installed with Google Cloud SDK above

# Install Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update && sudo apt install -y helm

# Install k9s for cluster management
curl -sS https://webi.sh/k9s | sh
source ~/.config/envman/PATH.env

# Install kubectx and kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Verify installations
kubectl version --client
helm version
k9s version
```

### 3. Container Security and Scanning
```bash
# Install Trivy for vulnerability scanning
sudo apt install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update && sudo apt install -y trivy

# Install Hadolint for Dockerfile linting
wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
sudo mv /tmp/hadolint /usr/local/bin/hadolint
sudo chmod +x /usr/local/bin/hadolint
```

## IDE and Editor Setup

### 1. Visual Studio Code
```bash
# Install VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
sudo apt update && sudo apt install -y code

# Install essential extensions via CLI
code --install-extension ms-vscode.vscode-yaml
code --install-extension hashicorp.terraform
code --install-extension redhat.ansible
code --install-extension ms-python.python
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension github.copilot
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
```

### 2. Alternative Editors
```bash
# Install Vim with plugins
sudo apt install -y vim

# Install Neovim (modern Vim alternative)
sudo apt install -y neovim

# Install Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update && sudo apt install -y sublime-text
```

## Environment Configuration

### 1. Shell Configuration (Bash/Zsh)
```bash
# Install Zsh and Oh My Zsh (optional but recommended)
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add useful aliases to .bashrc or .zshrc
cat >> ~/.bashrc << 'EOF'
# IaC Development Aliases
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'

alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'

alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias di='docker images'

# AWS aliases
alias awsp='aws-profile'
alias s3ls='aws s3 ls'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gb='git branch'
alias gco='git checkout'
EOF

source ~/.bashrc
```

### 2. Environment Variables
```bash
# Create environment configuration file
cat > ~/.env << 'EOF'
# Development Environment Variables
export EDITOR=vim
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_STDOUT_CALLBACK=yaml
export TERRAFORM_LOG_LEVEL=INFO
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Cloud Provider Variables (set as needed)
# export AWS_PROFILE=development
# export ARM_SUBSCRIPTION_ID=""
# export GOOGLE_APPLICATION_CREDENTIALS=""
EOF

# Source environment variables in shell configuration
echo 'source ~/.env' >> ~/.bashrc
```

### 3. SSH Configuration
```bash
# Create SSH config for common connections
mkdir -p ~/.ssh
chmod 700 ~/.ssh

cat > ~/.ssh/config << 'EOF'
# SSH Configuration for Development
Host bastion
    HostName bastion.company.com
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519
    Port 22
    ServerAliveInterval 60

Host dev-*
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519
    ProxyJump bastion
    ServerAliveInterval 60

Host vagrant
    HostName 127.0.0.1
    User vagrant
    Port 2222
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no
    IdentityFile ~/.vagrant.d/insecure_private_key
EOF

chmod 600 ~/.ssh/config
```

## Testing and Validation Tools

### 1. Infrastructure Testing
```bash
# Install InSpec for compliance testing
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec

# Install Terratest dependencies (Go)
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify Go installation
go version
```

### 2. Linting and Formatting Tools
```bash
# Install pre-commit for Git hooks
pipx install pre-commit

# Install YAML linting tools
pipx install yamllint

# Install shell script linting
sudo apt install -y shellcheck

# Install JSON tools
sudo apt install -y jq yq

# Create pre-commit configuration
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
  
  - repo: https://github.com/ansible/ansible-lint
    rev: v6.22.1
    hooks:
      - id: ansible-lint
  
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.6
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_docs
      - id: terraform_tflint
EOF

# Install pre-commit hooks
pre-commit install
```

### 3. Performance and Monitoring Tools
```bash
# Install system monitoring tools
sudo apt install -y \
  htop \
  iotop \
  nethogs \
  ncdu \
  tmux \
  screen

# Install network tools
sudo apt install -y \
  nmap \
  tcpdump \
  wireshark-common \
  traceroute \
  mtr
```

## Project-Specific Setup

### 1. Clone and Setup Project
```bash
# Clone the IaC repository
git clone https://github.com/your-org/iac-linux-configs.git
cd iac-linux-configs

# Install project dependencies
make install-deps

# Setup development environment
make setup-dev

# Verify setup
make test-tools
```

### 2. Create Development Workspace
```bash
# Create project workspace structure
mkdir -p ~/workspace/iac-projects/{development,staging,production}
mkdir -p ~/workspace/iac-projects/tools/{scripts,docs,templates}

# Create symbolic links for easy access
ln -s ~/workspace/iac-projects/iac-linux-configs ~/iac
```

### 3. Environment Validation Script
```bash
#!/bin/bash
# save as ~/bin/validate-dev-env.sh

echo "=== IaC Development Environment Validation ==="

# Check essential tools
tools=("terraform" "ansible" "packer" "docker" "kubectl" "helm" "aws" "az" "gcloud")
for tool in "${tools[@]}"; do
    if command -v $tool &> /dev/null; then
        version=$(${tool} --version 2>/dev/null | head -n1)
        echo "✓ $tool: $version"
    else
        echo "✗ $tool: NOT INSTALLED"
    fi
done

# Check Docker daemon
if docker info &> /dev/null; then
    echo "✓ Docker daemon: Running"
else
    echo "✗ Docker daemon: Not running"
fi

# Check cloud authentication
echo ""
echo "=== Cloud Authentication Status ==="

# AWS
if aws sts get-caller-identity &> /dev/null; then
    echo "✓ AWS: Authenticated"
else
    echo "✗ AWS: Not authenticated"
fi

# Azure
if az account show &> /dev/null; then
    echo "✓ Azure: Authenticated"
else
    echo "✗ Azure: Not authenticated"
fi

# GCP
if gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "✓ GCP: Authenticated"
else
    echo "✗ GCP: Not authenticated"
fi

echo ""
echo "=== Environment Setup Complete ==="
```

## Troubleshooting

### Common Issues and Solutions

#### 1. WSL2 Specific Issues
```bash
# Fix Docker daemon issues in WSL2
sudo service docker start

# Fix DNS resolution issues
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Fix memory issues
echo '[wsl2]
memory=8GB
swap=2GB' | sudo tee -a /etc/wsl.conf
```

#### 2. Permission Issues
```bash
# Fix Docker permission issues
sudo usermod -aG docker $USER
newgrp docker

# Fix SSH key permissions
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/id_*.pub
```

#### 3. Network Issues
```bash
# Test connectivity to cloud providers
curl -I https://aws.amazon.com
curl -I https://management.azure.com
curl -I https://www.googleapis.com

# Check DNS resolution
nslookup google.com
dig google.com
```

#### 4. Tool Installation Issues
```bash
# Clear package cache
sudo apt clean
sudo apt autoclean
sudo apt autoremove

# Fix broken packages
sudo dpkg --configure -a
sudo apt --fix-broken install
```

### Performance Optimization

#### 1. System Tuning
```bash
# Increase file watchers for development tools
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Optimize Git for large repositories
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256
```

#### 2. Development Workflow Optimization
```bash
# Use direnv for automatic environment loading
sudo apt install -y direnv
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

# Create .envrc for project
echo 'export ENVIRONMENT=development
export LOG_LEVEL=debug' > .envrc
direnv allow
```

## Maintenance and Updates

### Regular Maintenance Tasks
```bash
#!/bin/bash
# save as ~/bin/maintain-dev-env.sh

# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Python packages
pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U

# Update Node.js packages
npm update -g

# Update Ansible collections
ansible-galaxy collection install --upgrade -r requirements.yml

# Clean up Docker
docker system prune -f

# Update pre-commit hooks
pre-commit autoupdate

echo "Development environment maintenance complete!"
```

### Version Management
```bash
# Use version managers for consistent tool versions
# Node.js version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Python version manager
curl https://pyenv.run | bash

# Terraform version manager (already installed above)
tfenv install latest
tfenv use latest
```

This comprehensive guide ensures developers have everything needed to work effectively with the IaC project across different virtualization platforms while maintaining consistency and best practices.
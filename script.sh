#!/bin/bash
# setup-dev-environment.sh
# Script to set up the IaC development environment using Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists docker; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command_exists docker-compose; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # Check if Docker daemon is running
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker daemon is not running. Please start Docker first."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Create directory structure
create_directories() {
    print_status "Creating directory structure..."
    
    # Create main directories
    mkdir -p workspace/{projects,scripts,configs,docs}
    mkdir -p config/{aws,azure,gcloud,ssh}
    mkdir -p scripts
    mkdir -p docs
    mkdir -p test-content
    
    # Create example files
    cat > workspace/README.md << 'EOF'
# IaC Development Workspace

This directory is mounted into the Ubuntu development container at `/workspace`.

## Structure
- `projects/` - Your IaC projects and repositories
- `scripts/` - Development and utility scripts
- `configs/` - Configuration files and templates
- `docs/` - Documentation and notes

## Usage
1. Place your IaC projects in the `projects/` directory
2. The container has all necessary tools pre-installed
3. Use `validate-env` command inside the container to verify setup
EOF

    # Create a simple test HTML file
    cat > test-content/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>IaC Test Target</title>
</head>
<body>
    <h1>🚀 IaC Development Environment</h1>
    <p>This is a test target for your Infrastructure as Code deployments.</p>
    <p>Accessible at: <a href="http://localhost:8080">http://localhost:8080</a></p>
</body>
</html>
EOF

    # Create example configuration files
    cat > config/git/.gitconfig << 'EOF'
[user]
    name = Developer
    email = developer@example.com
[init]
    defaultBranch = main
[pull]
    rebase = false
[core]
    editor = vim
    autocrlf = input
EOF

    # Create SSH config example
    cat > config/ssh/config.example << 'EOF'
# SSH Configuration Example
# Copy this to 'config' and customize as needed

Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    StrictHostKeyChecking accept-new

# Example entries
# Host bastion
#     HostName bastion.example.com
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa
#     Port 22

# Host dev-*
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa
#     ProxyJump bastion
EOF

    print_success "Directory structure created"
}

# Create example scripts
create_example_scripts() {
    print_status "Creating example scripts..."
    
    # Create test script for the development environment
    cat > scripts/test-dev-env.sh << 'EOF'
#!/bin/bash
# Test script to validate development environment setup

echo "🧪 Testing IaC Development Environment"
echo "======================================"

# Test basic tools
echo "Testing basic tools..."
terraform version
ansible --version | head -n1
packer version
docker --version
kubectl version --client
helm version

echo ""
echo "Testing Python packages..."
python3 -c "import ansible; print('✓ Ansible available')"
python3 -c "import yaml; print('✓ PyYAML available')"
python3 -c "import jinja2; print('✓ Jinja2 available')"

echo ""
echo "Testing cloud CLI tools..."
aws --version
az --version | head -n1
gcloud --version | head -n1

echo ""
echo "✅ Development environment test completed!"
EOF

    # Create example Terraform test
    cat > scripts/test-terraform.sh << 'EOF'
#!/bin/bash
# Example Terraform test script

echo "🏗️  Testing Terraform functionality"
echo "=================================="

# Create a simple test configuration
mkdir -p /tmp/terraform-test
cd /tmp/terraform-test

cat > main.tf << 'TFEOF'
# Simple test configuration
terraform {
  required_version = ">= 1.0"
}

variable "test_var" {
  description = "Test variable"
  type        = string
  default     = "hello-terraform"
}

output "test_output" {
  value = "Test successful: ${var.test_var}"
}
TFEOF

echo "Initializing Terraform..."
terraform init

echo "Validating configuration..."
terraform validate

echo "Planning..."
terraform plan

echo "✅ Terraform test completed!"
rm -rf /tmp/terraform-test
EOF

    # Create example Ansible test
    cat > scripts/test-ansible.sh << 'EOF'
#!/bin/bash
# Example Ansible test script

echo "📋 Testing Ansible functionality"
echo "==============================="

# Create a simple playbook
mkdir -p /tmp/ansible-test
cd /tmp/ansible-test

cat > inventory << 'INVEOF'
[local]
localhost ansible_connection=local
INVEOF

cat > test-playbook.yml << 'PLAYBOOKEOF'
---
- name: Test Ansible functionality
  hosts: local
  gather_facts: yes
  tasks:
    - name: Display system information
      debug:
        msg: "Testing on {{ ansible_distribution }} {{ ansible_distribution_version }}"
    
    - name: Test file creation
      file:
        path: /tmp/ansible-test-file
        state: touch
    
    - name: Test template
      template:
        src: test.j2
        dest: /tmp/ansible-test-output
      vars:
        test_message: "Ansible is working!"
PLAYBOOKEOF

cat > test.j2 << 'TEMPLATEEOF'
{{ test_message }}
System: {{ ansible_distribution }}
Date: {{ ansible_date_time.date }}
TEMPLATEEOF

echo "Running Ansible playbook..."
ansible-playbook -i inventory test-playbook.yml

echo "Checking output..."
cat /tmp/ansible-test-output

echo "✅ Ansible test completed!"
rm -rf /tmp/ansible-test
EOF

    # Make scripts executable
    chmod +x scripts/*.sh
    
    print_success "Example scripts created"
}

# Build and start the environment
build_environment() {
    print_status "Building development environment..."
    
    # Build the Docker image
    docker-compose build ubuntu-dev
    
    print_success "Development environment built successfully"
}

# Start the environment
start_environment() {
    print_status "Starting development environment..."
    
    # Start the containers
    docker-compose up -d
    
    # Wait for containers to be ready
    print_status "Waiting for containers to start..."
    sleep 5
    
    # Check container status
    if docker-compose ps | grep -q "Up"; then
        print_success "Development environment started successfully"
        print_status "Container status:"
        docker-compose ps
    else
        print_error "Failed to start development environment"
        exit 1
    fi
}

# Display usage information
show_usage() {
    print_success "🚀 IaC Development Environment Setup Complete!"
    echo ""
    echo "📋 Usage Instructions:"
    echo "  Start environment:    docker-compose up -d"
    echo "  Stop environment:     docker-compose down"
    echo "  Access container:     docker-compose exec ubuntu-dev bash"
    echo "  View logs:           docker-compose logs ubuntu-dev"
    echo "  Rebuild:             docker-compose build"
    echo ""
    echo "📁 Directory Structure:"
    echo "  workspace/           - Your development files (mounted in container)"
    echo "  config/              - Configuration files for cloud tools"
    echo "  scripts/             - Test and utility scripts"
    echo ""
    echo "🔧 Inside the Container:"
    echo "  validate-env         - Check tool installation"
    echo "  /home/developer/test-scripts/ - Access to your test scripts"
    echo "  /workspace/          - Your mounted workspace"
    echo ""
    echo "🌐 Test Services:"
    echo "  Test target:         http://localhost:8080"
    echo ""
    echo "💡 Quick Start:"
    echo "  1. docker-compose exec ubuntu-dev bash"
    echo "  2. validate-env"
    echo "  3. cd /workspace && git clone <your-iac-repo>"
    echo ""
}

# Main execution
main() {
    echo "🚀 Setting up IaC Development Environment"
    echo "========================================"
    
    check_prerequisites
    create_directories
    create_example_scripts
    build_environment
    start_environment
    show_usage
}

# Parse command line arguments
case "${1:-setup}" in
    setup)
        main
        ;;
    build)
        build_environment
        ;;
    start)
        start_environment
        ;;
    stop)
        print_status "Stopping development environment..."
        docker-compose down
        print_success "Development environment stopped"
        ;;
    clean)
        print_status "Cleaning up development environment..."
        docker-compose down -v --rmi all
        print_success "Development environment cleaned up"
        ;;
    status)
        print_status "Development environment status:"
        docker-compose ps
        ;;
    logs)
        docker-compose logs ubuntu-dev
        ;;
    help|--help|-h)
        echo "IaC Development Environment Setup Script"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  setup    - Full setup (default)"
        echo "  build    - Build containers only"
        echo "  start    - Start containers only"
        echo "  stop     - Stop containers"
        echo "  clean    - Clean up everything"
        echo "  status   - Show container status"
        echo "  logs     - Show container logs"
        echo "  help     - Show this help"
        ;;
    *)
        print_error "Unknown command: $1"
        print_status "Use '$0 help' for usage information"
        exit 1
        ;;
esac
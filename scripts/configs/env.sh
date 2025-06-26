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
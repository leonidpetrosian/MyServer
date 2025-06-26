# Install pre-commit for Git hooks
pipx install pre-commit

# Install YAML linting tools
pipx install yamllint

# Install shell script linting
sudo apt install -y shellcheck

# Install JSON tools
sudo apt install -y jq yq

# Create pre-commit configuration
cat >.pre-commit-config.yaml <<'EOF'
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

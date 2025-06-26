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
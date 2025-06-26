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
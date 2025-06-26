# Install Git (if not already installed)
sudo apt install -y git

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"
git config --global init.defaultBranch main
git config --global pull.rebase false

# Optional: Configure SSH keys for Git
ssh-keygen -t ed25519 -C "your.email@company.com"

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
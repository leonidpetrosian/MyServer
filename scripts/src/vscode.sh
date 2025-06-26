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
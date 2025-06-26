# Install InSpec for compliance testing
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec

# Install Terratest dependencies (Go)
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify Go installation
go version
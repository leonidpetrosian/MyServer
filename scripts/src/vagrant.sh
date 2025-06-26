# Install Vagrant
sudo apt install -y vagrant

# Install common Vagrant plugins
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-disksize
vagrant plugin install vagrant-hostmanager

# Verify installation
vagrant version
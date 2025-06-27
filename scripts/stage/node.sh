# Install Node.js LTS via NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
node --version
npm --version

# Install global packages
npm install -g \
  yarn \
  @aws-cdk/cli \
  serverless \
  prettier \
  eslint

# TODO: Install nvm (Node Version Manager) and npx - Optional

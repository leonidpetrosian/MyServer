# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential build tools
sudo apt install -y \
  build-essential \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  gnupg \
  lsb-release \
  curl \
  wget \
  git \
  vim \
  unzip \
  jq \
  tree \
  htop \
  net-tools \
  dnsutils

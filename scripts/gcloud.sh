# Add Google Cloud SDK repository
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Install Google Cloud SDK
sudo apt update && sudo apt install -y google-cloud-cli

# Install additional components
sudo apt install -y \
  google-cloud-cli-gke-gcloud-auth-plugin \
  kubectl

# Verify installation
gcloud version
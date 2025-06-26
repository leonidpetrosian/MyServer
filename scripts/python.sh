# Install Python and pip
sudo apt install -y python3 python3-pip python3-venv python3-dev

# Install pipx for isolated Python applications
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Install Poetry for Python dependency management
pipx install poetry

# Install common Python packages
pip3 install --user \
  requests \
  pyyaml \
  jinja2 \
  netaddr \
  dnspython
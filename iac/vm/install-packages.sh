#!/bin/bash

# Install repositories and update all:
sudo add-apt-repository -y ppa:linbit/linbit-drbd9-stack

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get upgrade -y

# Install DRBD:
sudo apt-get install -y drbd-utils drbd-dkms

# Install OCFS2 and its modules:
sudo apt-get install -y ocfs2-tools
sudo apt install -y linux-modules-extra-gcp

# Install Docker:
sudo apt-get -y install docker-ce docker-ce-cli containerd.io \
                        docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USERNAME

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

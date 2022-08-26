#!/bin/sh

# Install docker
curl https://get.docker.com | sh
# sudo groupadd docker
sudo usermod -aG docker $USER
sudo service docker start

# Install k3s
# ! This requires systemd installation in advance.
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.18.20+k3s1 sh -s - --write-kubeconfig-mode 644 --no-deploy traefik --docker
echo "You need to reopen a wsl shell to run 'docker ps' without sudo."
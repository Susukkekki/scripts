#!/bin/sh
# ! This requires systemd installation in advance.
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.18.20+k3s1 sh -s - --write-kubeconfig-mode 644 --no-deploy traefik --docker
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc

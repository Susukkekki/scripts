#!/bin/sh
# ! This requires systemd installation in advance.
# ! In case of v1.24.4+k3s1, gpu scheduling did not work.
# ! v1.18.20+k3s1 was confirmed if gpu scheduling works. but it has problem with kubeflow (requires over v1.21 kubernetes)
# v1.21.14+k3s1
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.14+k3s1 sh -s - --write-kubeconfig-mode 644 --no-deploy traefik --docker
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc

#!/bin/sh
# ! This requires systemd installation in advance.
# ! In case of v1.24.4+k3s1, gpu scheduling did not work.
# ! v1.21.14+k3s1 did not work with custom device plugin.
# ! v1.20.15-rc1+k3s1 did not work with custom device plugin.
# ! v1.19.16+k3s1 did not work with custom device plugin.
# ! v1.18.20+k3s1 was confirmed if gpu scheduling works. but it has problem with kubeflow (requires over v1.21 kubernetes)
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.18.20+k3s1 sh -s - --write-kubeconfig-mode 644 --no-deploy traefik --docker
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc

# /usr/local/bin/k3s-uninstall.sh
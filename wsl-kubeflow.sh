#!/bin/sh

# Install Kustomize v3.2
mkdir -p ~/temp
cd ~/temp
wget https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64
chmod +x kustomize_3.2.0_linux_amd64
sudo mv kustomize_3.2.0_linux_amd64 /usr/local/bin/kustomize

# Install manifest
git clone https://github.com/kubeflow/manifests.git
cd manifests

while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done


#!/bin/sh

# Install Kustomize v3.2
mkdir -p ~/temp
cd ~/temp
wget https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64
chmod +x kustomize_3.2.0_linux_amd64
sudo mv kustomize_3.2.0_linux_amd64 /usr/local/bin/kustomize

# Install manifest
# !v1.3.1-rc.1 : Failed to pull image of kfserving-controller-manager-0 because it's deprecated. (gcr.io/kfserving/kfserving-controller:v0.5.1)
# !v1.4.0-rc.2 : Failed to pull image of kfserving-controller-manager-0 because it's deprecated. (gcr.io/kfserving/kfserving-controller:v0.6.0)
#   but after updating it to kfserving/kfserving-controller:v0.6.1, it worked.
# !v1.5.0-rc.2 is not compatible with k3s v1.18
git clone https://github.com/kubeflow/manifests.git -b v1.4.0-rc.2
cd manifests

while ! kustomize build example | kubectl apply -f -; do echo "Retrying to apply resources"; sleep 10; done

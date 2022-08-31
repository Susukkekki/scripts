#!/bin/sh

# install cuda
mkdir -p ~/temp
cd ~/temp
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-wsl-ubuntu-11-7-local_11.7.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-11-7-local_11.7.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-11-7-local/cuda-B81839D3-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
nvidia-smi

# install docker
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

sudo service docker start

# install container tookit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo service docker restart

echo "Waiting for docker to be started..."
for i in {1..11}; do
    sleep 1
    if sudo service docker status | grep -q "Docker is running"; then
        break
    fi

    echo "  Trying $i ..."

    if test $i -eq 10; then
        echo "Error: Docker might not be running!"
        exit 1
    fi
done

sudo docker run --gpus 1 nvidia/cuda:11.7.0-base-ubuntu18.04 nvidia-smi

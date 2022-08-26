#!/bin/sh
curl https://get.docker.com | sh
# sudo groupadd docker
sudo usermod -aG docker $USER
sudo service docker start
echo "You need to reopen a wsl shell to run 'docker ps' without sudo."

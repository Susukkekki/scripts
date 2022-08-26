#!/bin/sh
curl https://get.docker.com | sh
# sudo groupadd docker
sudo usermod -aG docker $USER
sudo service docker start
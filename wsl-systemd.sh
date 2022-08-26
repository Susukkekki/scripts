#!/bin/sh
mkdir ~/temp
cd ~/temp
git clone https://github.com/DamionGans/ubuntu-wsl2-systemd-script.git
cd ubuntu-wsl2-systemd-script/
bash ubuntu-wsl2-systemd-script.sh

echo "You need to reopen a wsl shell after exiting this shell."

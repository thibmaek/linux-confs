#!/usr/bin/env bash

# ▲ Checks and installs the correct version of Node
#   for (Raspberry Pi) ARMv7 and updates npm to latest.

if grep "VERSION=" /etc/os-release | grep -q "[0-7]"; then
  # Install v4 (for building native addons) for Debian Wheezy or lower (>=7)
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
else
  # Install latest (v8) for Debian Jessie or higher (8+)
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
fi

# Install node from the apt-source list & update npm
apt install nodejs
sudo npm install -g npm

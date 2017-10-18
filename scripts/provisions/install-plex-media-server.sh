#!/usr/bin/env bash

# Require sudo to run this script for apt
if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit 1;
fi

# Get the GPG key from the dev2day repo and add the repo to tha apt sources
wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | apt-key add -
echo "deb https://dev2day.de/pms/ stretch main" | tee /etc/apt/sources.list.d/pms.list

# Update the apt database with the new repo and install plexmediaserver
apt update
apt install plexmediaserver-installer

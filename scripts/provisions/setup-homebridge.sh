#!/usr/bin/env bash

# ▲ Installs homebridge and sets up a systemd unit

# Require sudo to run this script for npm & apt
if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit 1;
fi

# Check if node is installed
if ! node -v > /dev/null; then
  echo '[WARN]: Node not installed.'
  exit 1;
fi

# Install dependencies and global homebridge binary
# NOTE: --unsafe-perm is needed to avoid an issue with node-gyp on ARMv6 & ARMv7 devices
apt install libavahi-compat-libdnssd-dev
npm install -g homebridge --unsafe-perm

# Copy the repo systemd unit to the systemd folder
cp ../../etc/systemd/homebridge.service /etc/systemd/

# Add a non-privileged user for running homebridge and create a working directory
useradd --system homebridge
mkdir /var/homebridge

# If there was a previous configuration dir, copy it over to the new working directory
if [[ -d "$HOME/.homebridge"  ]]; then
  cp "$HOME/.homebridge/config.json" /var/homebridge/
  cp -r "$HOME/.homebridge/persist" /var/homebridge
fi

# Set unsafe permissions on working dir for easier access
chmod -R 0777 /var/homebridge

# Reload, enable and start the systemd service
systemctl daemon-reload && systemctl enable homebridge
systemctl start homebridge

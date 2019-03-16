#!/usr/bin/env bash
set -e

#  TODO: url
# ▲ Installs the homebridge: https://...

if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, systemd, npm, chmod, useradd]"
  echo ""
  exit 1
fi

function check_requirements() {
  if command -v node > /dev/null; then
    echo "[WARN]: Node not installed and is required by this script."
    exit 1
  fi
}

function install_packages() {
  echo "Installing required pacakges and homebridge through npm"
  apt install libavahi-compat-libdnssd-dev && \
    npm install --unsafe-perm -g homebridge
}

function setup_application() {
  echo "Adding a new system user for homebridge and creating its home directory"
  useradd --system homebridge && \
    mkdir /var/homebridge && \
    chmod -R 0777 /var/homebridge

  cp homebridge.service /etc/systemd/system/ && \
    systemctl daemon-reload && \
    systemctl enable homebridge && \
    systemctl start homebridge
}

function main() {
  check_requirements && \
    install_packages && \
    setup_application && \
      echo "" && \
      echo "homebridge was successfully installed and automatically started."
}

"${@:-main}"

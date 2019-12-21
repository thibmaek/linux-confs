#!/usr/bin/env bash
set -e

#  TODO: url
# ▲ Installs Plex Media Server: https://...

if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, systemd]"
  echo ""
  exit 1
fi

function install_repo() {
  echo "Installing Plex Media Server repository from https://dev2day.de"
  wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | apt-key add - && \
    echo "deb https://dev2day.de/pms/ stretch main" | tee /etc/apt/sources.list.d/pms.list
}

function install_packages() {
  apt update && \
    apt install plexmediaserver-installer
}

function main() {
  install_repo && \
    install_packages && \
    echo "" && \
    echo "Plex Media Server was successfully installed and automatically started."
    echo "Plex is available at http://$HOSTNAME:32400"
}

"${@:-main}"

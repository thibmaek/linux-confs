#!/usr/bin/env bash
set -e

# ▲ Installs the MiFlora MQTT daemon: https://github.com/ThomDietrich/miflora-mqtt-daemon

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, pip3, systemctl, cp]"
  echo ""
  exit
fi

REPO_CLONE_DIR="/opt/miflora-mqtt-daemon"

function install_packages() {
  echo "Installing required packages..."
  apt install git && \
    apt install python3 python3-pip && \
    apt install bluetooth bluez
}

function install_repo() {
  local prevDir
  prevDir=$(pwd)

  echo "Cloning ThomDietrich/miflora-mqtt-daemon to $REPO_CLONE_DIR"
  git clone https://github.com/ThomDietrich/miflora-mqtt-daemon.git "$REPO_CLONE_DIR"
  cd "$REPO_CLONE_DIR"

  echo "Installing repo and configuring..."
  pip3 install -r requirements.txt
  cp "$REPO_CLONE_DIR"/config.{ini.dist,ini}
  cd "$prevDir"

  echo ""
  echo "Systemd service is not automatically installed because config needs to be finetuned first."
  echo "Edit $REPO_CLONE_DIR/config.ini first and then install the service using:"
  echo "  $ ./install-miflora-mqtt-daemon.sh install_systemd_service"
  echo ""
}

function install_systemd_service() {
  cp "$REPO_CLONE_DIR"/template.service /etc/systemd/system/miflora-mqtt-daemon.service
  systemctl daemon-reload

  systemctl start miflora-mqtt-daemon.service
  systemctl status miflora-mqtt-daemon.service

  systemctl enable miflora-mqtt-daemon.service
}

function main() {
  install_packages
  install_repo
}

"${@:-main}"

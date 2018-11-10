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
  apt install git && \
    apt install python3 python3-pip && \
    apt install bluetooth bluez
}

function install_repo() {
  local PREV_DIR
  PREV_DIR=$(pwd)

  git clone https://github.com/ThomDietrich/miflora-mqtt-daemon.git "$REPO_CLONE_DIR"
  cd "$REPO_CLONE_DIR"
  sudo pip3 install -r requirements.txt

  cp "$REPO_CLONE_DIR"/config.{ini.dist,ini}

  cd "$PREV_DIR"

  echo ""
  echo "Systemd service is not automatically installed because config needs to be finetuned first."
  echo "Edit $REPO_CLONE_DIR/config.ini first and then install the service using:"
  echo "  \$ ./install-miflora-mqtt-daemon.sh install_systemd_service"
  echo ""
}

function install_systemd_service() {
  sudo cp "$REPO_CLONE_DIR"/template.service /etc/systemd/system/miflora-mqtt-daemon.service
  sudo systemctl daemon-reload

  sudo systemctl start miflora-mqtt-daemon.service
  sudo systemctl status miflora-mqtt-daemon.service

  sudo systemctl enable miflora-mqtt-daemon.service
}

function main() {
  install_packages
  install_repo
}

"${@:-main}"

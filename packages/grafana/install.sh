#!/usr/bin/env bash
set -e

# ▲ Installs Granafa: https://grafana.com/

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [dpkg, systemd]"
  echo ""
  exit
fi

function install_packages() {
  wget https://dl.grafana.com/oss/release/grafana_5.4.2_armhf.deb
  dpkg -i grafana_5.4.2_armhf.deb

  systemctl enable grafana-server
  systemctl start grafana-server
}

function main() {
  install_packages && \
    echo "" && \
    echo "Grafana was successfully installed and automatically started." && \
    echo "Grafana is available at http://$HOSTNAME:3000"
}

"${@:-main}"

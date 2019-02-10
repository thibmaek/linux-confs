#!/usr/bin/env bash
set -e

# ▲ Installs Telegraf: https://www.influxdata.com/time-series-platform/telegraf/

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, systemd]"
  echo ""
  exit
fi

function install_packages() {
  curl -sL https://repos.influxdata.com/influxdb.key | apt-key add -
  echo "deb https://repos.influxdata.com/debian stretch stable" | \
    tee /etc/apt/sources.list.d/influxdb.list

  apt update
  apt install telegraf

  systemctl enable telegraf
  systemctl start telegraf
}

function main() {
  apt update

  echo "Installing required packages for apt usage over HTTPS..."
  apt install apt-transport-https

  install_packages && \
    echo "" && \
    echo "Telegraf was successfully installed and automatically started."
}

"${@:-main}"

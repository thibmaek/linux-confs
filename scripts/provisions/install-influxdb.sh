#!/usr/bin/env bash
set -e

# ▲ Installs InfluxDB: https://www.influxdata.com/

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
  apt install influxdb

  systemctl enable influxdb
  systemctl start influxdb
}

function main() {
  install_packages && \
    echo "" && \
    echo "InfluxDB was successfully installed and automatically started." && \
    echo "Dont't forget to create a database and a user." && \
    echo "InfluxDB's HTTP API is available at http://$HOSTNAME:8086"
}

"${@:-main}"

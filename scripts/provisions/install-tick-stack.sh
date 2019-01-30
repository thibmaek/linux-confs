#!/usr/bin/env bash
set -e

# ▲ Installs TICK stack: Telegraf, InfluxDB, Chronograf, Kapacitor

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, systemd]"
  echo ""
  exit
fi

function install_packages() {
  local tickstack=(telegraf influxdb chronograf kapacitor)
  curl -sL https://repos.influxdata.com/influxdb.key | apt-key add -
  echo "deb https://repos.influxdata.com/debian stretch stable" | \
    tee /etc/apt/sources.list.d/influxdb.list

  apt update

  for component in "${tickstack[@]}"; do
    apt install "$component"
    systemctl enable "$component"
    systemctl start "$component"
  done

  unset tickstack
}

function main() {
  install_packages && \
    echo "" && \
    echo "TICK stack was successfully installed and automatically started." && \
    echo " - InfluxDB: Dont't forget to create a database and a user. HTTP API is available at http://$HOSTNAME:8086" && \
    echo " - Chronograf: Web interface is available at http://$HOSTNAME:8888"
}

"${@:-main}"

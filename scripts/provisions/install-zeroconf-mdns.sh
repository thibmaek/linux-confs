#!/usr/bin/env bash
set -e

# ▲ Installs ZeroConf (mDNS, Bonjour, Avahi)

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt]"
  echo ""
  exit
fi

function main() {
  apt install avahi-daemon avahi-discover libnss-mdns && \
    avahi-discover
}
main

#!/usr/bin/env bash
set -e

# ▲ Installs CUPS and hplip

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit
fi

function install_packages() {
  # Install CUPS
  apt install cups

  # Install hplip
  apt install hplip
}

function main() {
  install_packages

  # Add the pi use to the
  usermod -a -G lpadmin "$(whoami)"

  echo ""
  echo "hplip was successfully installed."
  echo "Use hp-setup to set up a printer on the network or over USB"
  echo ""
  echo "  e.g. $ hp-setup -i myprinter.local"
  echo ""
}

"${@:-main}"

#!/usr/bin/env bash
set -e

#  TODO: url
# ▲ Installs SickChill: https://...

if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, systemd, pip, cp]"
  echo "  Possibly required permissions: [dpkg]"
  echo ""
  exit 1
fi

function install_packages() {
  echo "Installing required packages"
  apt install install python-pip python-dev git libssl-dev libxslt1-dev libxslt1.1 \
    libxml2-dev libxml2 libssl-dev libffi-dev build-essential

  echo "Installing pyopenssl (via pip)"
  pip install pyopenssl
}

function install_application() {
  # TODO: correct repo
  echo "Cloning official SickChill repo"
  git clone https://github.com/SickRage/SickRage "$1"

  sed -e "s/<user>/$USER/" template.service > sickchill.service && \
    cp sickchill.service /etc/systemd/system/
    systemctl daemon-reload && \
    systemctl enable sickchill && \
    systemctl start sickchill
}

function build_unrar_from_source() {
  # TODO: newer version?
  wget http://sourceforge.net/projects/bananapi/files/unrar_5.2.6-1_armhf.deb
  dpkg -i unrar_5.2.6-1_armhf.deb
}

function main() {
  echo "  sudo ./$(basename "$0") build_unrar_from_source"
  exit 1

  local sickChillHome="$HOME/.sickChill"
  apt update

  install_packages && \
    install_repo "$sickChillHome" && \
    echo "" && \
    echo "SickChill was successfully installed and automatically started." && \
    echo "If you want support for RAR files you can run the following" && \
    echo "to build unrar (non-free) from source:" && \
    echo "  sudo ./$(basename "$0") build_unrar_from_source"
}

"${@:-main}"

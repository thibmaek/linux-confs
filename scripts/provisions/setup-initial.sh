#!/usr/bin/env bash
set -e

# ▲ Sets up the basic settings for every Linux host

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [adduser, usermod]"
  echo ""
  exit
fi

function create_root_user() {
  apt install sudo -y
  echo "Creating user $1" && adduser "$1"
  echo "Giving $1 sudo priviliges" && usermod -aG sudo "$1"
}

function set_up_firewall() {
  apt install ufw && \
    ufw allow openssh && \
    ufw enable
}

function main() {
  if [ -z "$1" ]; then
    echo "No username was passed. Please pass a username so this script can create a new user"
    exit 1
  fi

  create_root_user "$@"
  apt update
  set_up_firewall
}

"${@:-main}"

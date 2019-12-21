#!/usr/bin/env bash
set -e

#  TODO: url
# ▲ Installs Node.js for ARM architectures: https://...

if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, bash, npm]"
  echo ""
  exit 1
fi

function install_repo() {
  # TODO: use official node mirror?
  echo "Installing node@$1 from deb.nodesource.com"
  curl -sL "https://deb.nodesource.com/setup_$1.x" | bash - && \
    apt update && \
    apt install nodejs

  echo "Updating to latest npm"
  npm install -g npm
}

function main() {
  local nodeVersion

  if [ -z "$1" ]; then
    nodeVersion="10"
  else
    nodeVersion="$1"
  fi

  # TODO: check cpu architecture
  install_repo "$nodeVersion" && \
    echo "" && \
    echo "Node was successfully installed." && \
    echo "  node version: $(node -v)" && \
    echo "Running versions: $(npm -v)"

  unset nodeVersion
}

"${@:-main}"

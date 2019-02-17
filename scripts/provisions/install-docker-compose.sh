#!/usr/bin/env bash
set -e

# ▲ Installs docker-compose. Defaults to git but can also install from apt

if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [curl, apt, chmod]"
  echo ""
  exit 1
fi

# This function is only callable on the script and not part of the main() function
function install_from_apt() {
  echo "Installing docker-compose from apt."
  echo "The version installed might be behind on the most recently available version"
  echo "from the official docker-compose git repository."
  apt update
  apt install docker-compose
}

function install_from_git() {
  # We always want latest/stable
  downloadURL=$(curl -s "https://api.github.com/repos/docker/compose/releases/latest" \
    | grep "browser_download_url" \
    | grep "$(uname -s)-$(uname -m)" \
    | grep -v ".sha256" \
    | cut -d '"' -f 4)

  echo "Installing docker-compose from the official git repository."
  curl -L "$downloadURL" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

  echo "Installing bash completion."
  curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
}

function main() {
  if ! command -v docker > /dev/null; then
    echo "It seems like Docker is not installed."
    echo "This script can not be run until Docker CE is installed!"
    exit 1
  fi

  install_from_git && \
    echo "" && \
    echo "Docker Compose was successfully installed." && \
    echo "Bash completion was installed to /etc/bash_completion.d/docker-compose" && \
    echo "  $(docker-compose --version)"
}

"${@:-main}"

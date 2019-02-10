#! /usr/bin/env bash
set -e

# ▲ Installs Docker CE for 64-bit Linux Debian

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, apt-key, usermod]"
  echo ""
  exit
fi

function get_docker_repo() {
  echo "Getting Docker's GPG key and verifying..."
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
  apt-key fingerprint 0EBFCD88 | grep -q "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88" \
    && echo "Docker GPG key verified"

  echo "Adding Docker's 'stable' repository to apt..."
  add-apt-repository \
    "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
}

function install_docker_ce() {
  apt update
  apt-cache policy docker-ce
  echo "Installing docker-ce and docker-ce-cli..."
  apt install docker-ce docker-ce-cli
}

# This function is only callable on the script and not part of the main() function
function use_overlay2_storage_driver() {
  if docker info | grep "Storage Driver: overlay2"; then
    echo "Docker is already using overlay2 as its storage driver."
    exit 0
  fi

  systemctl stop docker
  cp -au /var/lib/docker /var/lib/docker.bk
  {
    :;
    echo "{"
    echo "  \"storage-driver\": \"overlay2\""
    echo "}"
  } >> /etc/docker/daemon.json
  systemctl start docker
  docker info | grep "Storage Driver"
}

function uninstall() {
  systemctl stop docker
  apt purge docker-ce && rm -rf /var/lib/docker
}

function main() {
  apt update

  echo "Installing required packages for apt usage over HTTPS..."
  apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common

  get_docker_repo && \
    install_docker_ce && \
    usermod -aG docker "$USER" && \
    echo "" && \
    echo "Docker was successfully installed and automatically started." && \
    echo "Current user $USER has been added to the docker group" && \
    echo "If you want to enable overlay2 support, rerun this script:" && \
    echo "  sudo ./install-docker-ce.sh use_overlay2_storage_driver"
}

"${@:-main}"

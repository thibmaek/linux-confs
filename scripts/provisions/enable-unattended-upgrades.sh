#!/usr/bin/env bash
set -e

# ▲ Enables unattended upgrades (patches, security fixes etc.)
#   See: https://wiki.debian.org/UnattendedUpgrades

if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt]"
  echo ""
  exit 1
fi

function install_packages() {
  apt install unattended-upgrades apt-listchanges
}

function enable_upgrades() {
  echo "Backing up apt configuration to /etc/apt/apt.conf.d/50unattended-upgrades.orig"
  cp /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades.orig

  echo "Writing base configuration to to /etc/apt/apt.conf.d/50unattended-upgrades"
  # TODO: EOF
  {
    :;
    echo "Unattended-Upgrade::Origins-Pattern {"
    echo "  \"origin=Debian,codename=\${distro_codename},label=Debian-Security\";"
    echo "};"
    echo ""
    echo "Unattended-Upgrade::Package-Blacklist {"
    echo "};"
    echo ""
    echo "Unattended-Upgrade::Mail \"root\";"
  } > /etc/apt/apt.conf.d/50unattended-upgrades

  if ! grep "APT::Periodic::Update-Package-Lists \"1\";" /etc/apt/apt.conf.d/20auto-upgrades; then
    echo "/etc/apt/apt.conf.d/20auto-upgrades is outdated."
    echo "Reconfiguring it now using dpkg-reconfigure in noninteractive mode"
    echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
    dpkg-reconfigure -f noninteractive unattended-upgrades
  fi
}

function main() {
  install_packages && \
    enable_auto_updates && \
    echo "Unattended upgrades have been enabled for this system."
}

"${@:-main}"

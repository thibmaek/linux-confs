#!/usr/bin/env bash
set -e

# ▲ Installs Samba/CIFS: https://www.samba.org/

if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, systemd, cp, smbpasswd]"
  echo "  Possibly required permissions: [ufw, usermod]"
  echo ""
  exit 1
fi

function install_samba() {
  apt update && \
    apt install samba && \
    systemctl stop smbd
}

function setup_samba_base() {
  cp /etc/samba/smbd.conf /etc/samba/smbd.orig
  smbpasswd -a "$USER"
  if ! groups "$USER" | grep -qw "users"; then
    usermod -aG users "$USER"
  fi
  grep -v -E "^#|^;" /etc/samba/smb.orig | grep . > /etc/samba/smb.conf
}

function allow_ufw_rule() {
  if command -v ufw; then
    if ufw status | grep -qw active; then
      ufw allow samba && ufw reload
    fi
  fi
}

function main() {
  install_samba && \
    setup_samba_base && \
    allow_ufw_rule && \
    echo "" && \
    echo "Samba was successfully installed and automatically started." && \
    echo "You can connect to the shares defined in /etc/samba/smb.conf using:" && \
    echo "  smb://$HOSTNAME" && \
    echo "" && \
    echo "Define additional shares to /etc/samba/smb.conf"
}

"${@:-main}"

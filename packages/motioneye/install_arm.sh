#!/usr/bin/env bash
set -e

# TODO: url
# ▲ Installs motioneye for armhf architectures (Raspberry Pi):

if [[ "$EUID" -ne 0 ]]; then
  echo ""
  echo "[WARN]: Please run this script as root"
  echo "  Required permissions: [apt, systemd, mkdir, dpkg, pip, cp]"
  echo ""
  exit 1
fi

function install_packages() {
  echo "Installing motion dependencies"
  apt install ffmpeg libmariadbclient18 libpq5 libmicrohttpd12

  echo "Installing motion from the official git repository for most recent version"
  echo "This replaces the pre-bundled motion@4 that comes with Debian"
  wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_stretch_motion_4.2.2-1_armhf.deb && \
    dpkg -i pi_stretch_motion_4.2.2-1_armhf.deb

  echo "Installing motioneye dependencies"
  apt install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev && \
    pip install motioneye
}

function setup_application() {
  echo "Copying the default motioneye config"
  mkdir -p /etc/motioneye && \
    cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf &&\
    mkdir -p /var/lib/motioneye

  echo "Copying the default motioneye systemd service"
  cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service && \
    systemctl daemon-reload && \
    systemctl enable motioneye && \
    systemctl start motioneye
}

function main() {
  install_packages && \
    setup_application && \
      echo "" && \
      echo "motioneye was succesfully installed and automatically started" && \
      echo "To upgrade to future versions of motioneye run:" && \
      echo "  pip install motioneye --upgrade" && \
      echo "  systemctl restart motioneye" && \
      echo "" && \
      echo "motioneye service was auto started. Service running at:" && \
      echo "  http://$HOSTNAME:8765"
}

"${@:-main}"

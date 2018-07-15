#!/usr/bin/env bash

# ▲ Installs motioneye for armhf architectures (Raspberry Pi)

# Check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit
fi

# Install FFmpeg for video transformation
apt install ffmpeg

# Install MariaDB & Postgres deps required for motion
apt install libmariadbclient18 libpq5

# Download & install motion from the official Github project
# This replaces the pre-bundled motion@4 that comes with Raspbian Stretch
wget https://github.com/Motion-Project/motion/releases/download/release-4.1.1/pi_stretch_motion_4.1.1-1_armhf.deb
dpkg -i pi_stretch_motion_4.1.1-1_armhf.deb

# Install motioneye dependencies
apt install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev

# Install motioneye trough pip
pip install motioneye

# Prepare config & media dirs for motioneye
mkdir -p /etc/motioneye
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
mkdir -p /var/lib/motioneye

# Copy, install & run the motioneye systemd service
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
systemctl daemon-reload
systemctl enable motioneye
systemctl start motioneye

echo "motioneye was succesfully installed!"
echo "To upgrade to future versions of motioneye just run:"
echo "  pip install motioneye --upgrade"
echo "  systemctl restart motioneye"
echo ""
echo "motioneye service was auto started. Service running at:"
echo "  - http://localhost:8765"
echo "  - http://$(hostname).local:8765"

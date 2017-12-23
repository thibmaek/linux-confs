#!/usr/bin/env bash

# ▲ Installs SickRage from the official repository
#   and sets up easy permissions & systemd unit

# @private
buildUnrar=false
sickrageRepo=https://github.com/SickRage/SickRage

# Require sudo to run this script for apt
if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit 1;
fi

apt install install python-pip python-dev git libssl-dev libxslt1-dev libxslt1.1 \
  libxml2-dev libxml2 libssl-dev libffi-dev build-essential

pip install pyopenssl

git clone "$sickrageRepo" "$HOME/.sickrage"

cp ../../etc/systemd/system/sickrage.service /etc/systemd/system/

echo "Build & install unrar from source?"
select yn in "Yes" "No"; do
  case $yn in
      Yes ) buildUnrar=true; break;; # correct
      No ) break;;
  esac
done

if [[ $buildUnrar = true ]]; then
  wget http://sourceforge.net/projects/bananapi/files/unrar_5.2.6-1_armhf.deb
  dpkg -i unrar_5.2.6-1_armhf.deb
fi

systemctl enable sickrage.service
systemctl daemon-reload
systemctl start sickrage

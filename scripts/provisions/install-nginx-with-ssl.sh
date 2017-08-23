#!/usr/bin/env bash

# ▲ Installs nginx and sets up a boilerplate reverse proxy
#   with self signed OpenSSL certificates.

# @protected: nginx directory
_NGINX_DIR=/etc/nginx

if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit
fi

# Install Nginx & stop the systemd service
apt-get install nginx -y
systemctl stop nginx

# Create a self-signed certificate & dhparams file
# and move them to the right directory
openssl req -x509 -newkey rsa:2048 -keyout $_NGINX_DIR/ssl/key.pem -out $_NGINX_DIR/ssl/cert.pem -days 9999
openssl rsa -in $_NGINX_DIR/ssl/key.pem -out $_NGINX_DIR/ssl/key.pem
chmod 600 $_NGINX_DIR/ssl/key.pem $_NGINX_DIR/ssl/cert.pem
chown root:root $_NGINX_DIR/ssl/key.pem $_NGINX_DIR/ssl/cert.pem
openssl dhparam -out $_NGINX_DIR/ssl/dhparams.pem 2048

# Unlink the default symlinked site and enable
# our reverse proxy file
unlink $_NGINX_DIR/sites-enabled
cp ../../etc/nginx/reverse $_NGINX_DIR/sites-available/reverse
ln $_NGINX_DIR/sites-available/reverse $_NGINX_DIR/sites-enabled/default

# Check if the nginx config is valid, then start the service
nginx -t && systemctl start nginx

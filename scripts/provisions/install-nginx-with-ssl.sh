#!/usr/bin/env bash

NGINX_DIR=/etc/nginx

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script as root"
  exit
fi

# Install Nginx & stop the systemd service
apt-get install nginx -y
systemctl stop nginx

# Create a self-signed certificate & dhparams file
# and move them to the right directory
openssl req -x509 -newkey rsa:2048 -keyout $NGINX_DIR/ssl/key.pem -out $NGINX_DIR/ssl/cert.pem -days 9999
openssl rsa -in $NGINX_DIR/ssl/key.pem -out $NGINX_DIR/ssl/key.pem
chmod 600 $NGINX_DIR/ssl/key.pem $NGINX_DIR/ssl/cert.pem
chown root:root $NGINX_DIR/ssl/key.pem $NGINX_DIR/ssl/cert.pem
openssl dhparam -out $NGINX_DIR/ssl/dhparams.pem 2048

# Unlink the default symlinked site and enable
# our reverse proxy file
unlink $NGINX_DIR/sites-enabled
cp ../../etc/nginx/reverse $NGINX_DIR/sites-available/reverse
ln $NGINX_DIR/sites-available/reverse $NGINX_DIR/sites-enabled/default

# Check if the nginx config is valid, then start the service
nginx -t && systemctl start nginx

#!/usr/bin/env bash

# ▲ Creates a new LetsEncrypt certificate with certbot
#   and sets up auto renewal

# -d <domain>: The FQDN to create a certificate for
# -e <email>: Email address to sign the certificate to.
DOMAIN=
EMAIL=

while getopts "h?d:e:" opt; do
  case $opt in
    d) DOMAIN=$OPTARG
      ;;
    e) EMAIL=$OPTARG
      ;;
    h|\?)
      echo "Syntax: ./create-letsencrypt-cert-apt-nginx.sh -d <domain> -e <email>" >&2
      exit 1
      ;;
  esac
done

if [[ "$EUID" -ne 0 ]]; then
  echo "[WARN]: Please run this script as root"
  exit
fi

# Install certbot from apt (requires ppa ppa:certbot/certbot on Ubuntu, Debian >=9)
apt install certbot python-certbot-nginx

# Generate a certificate at /etc/letsencrypt/live and set up for given nginx deomain
certbot --nginx --email "$EMAIL" -d "$DOMAIN"

# Add auto-renewal script to the user's crontab if certs are generated
if [[ -d /etc/letsencrypt/live ]]; then
  (crontab -l 2>/dev/null; echo "40 11,23 * * * certbot renew --quiet --no-self-upgrade) | crontab -")
fi

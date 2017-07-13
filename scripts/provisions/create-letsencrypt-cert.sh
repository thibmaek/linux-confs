#!/usr/bin/env bash
# @protected: location to download certbot-auto from
_CERTBOT_URL=https://dl.eff.org/certbot-auto

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
      echo "Syntax: ./create-letsencrypt-cert.sh -d <domain> -e <email>" >&2
      exit 1
      ;;
  esac
done

# Create a new isolated directory only if it doesn't exist
if [[ ! -d $HOME/.certbot && ! -f $HOME/.certbot/certbot-auto ]]; then
  mkdir -p $HOME/.certbot
  wget -P $HOME/.certbot $_CERTBOT_URL
  chmod a+x $HOME/.certbot/certbot-auto
fi

# Generate a certificate at /etc/letsencrypt/live
$HOME/.certbot/certbot-auto certonly --standalone \
                                     --preferred-challenges http-01 \
                                     --email $EMAIL \
                                     -d $DOMAIN

# Add auto-renewal script to the user's crontab
(crontab -l 2>/dev/null; echo "40 11,23 * * * $HOME/.certbot/certbot-auto renew --quiet --no-self-upgrade >> $HOME/.certbot/certbot_renew.log") | crontab -

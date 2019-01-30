#!/usr/bin/env bash

# ▲ Creates a self signed SSL certificate, key and D-H Params file.

# -e <days>: generate a certificate with a certain expiriation in days (default: 9999)
EXPIRY=9999

while getopts "h?e:" opt; do
  case $opt in
    e) EXPIRY=$OPTARG
      ;;
    h|\?)
      echo "Syntax: -e <days> to specify expiration for certificate" >&2
      exit 1
      ;;
  esac
done

openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days "$EXPIRY"
openssl rsa -in key.pem -out key.pem
openssl dhparam -out dhparams.pem 2048

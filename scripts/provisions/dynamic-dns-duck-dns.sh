#!/usr/bin/env bash

# -d <domain>: The Duck DNS domain to update
# -t <token>: Duck DNS token to authenticate with the service
DOMAIN=
TOKEN=

function uninstall_duck_dns() {
  echo "Uninstalling…"
  rm -rf "$HOME/.duckdns"
  crontab -l | grep -v '/.duckdns/update.sh'  | crontab -
  echo "Deleted $HOME/.duckdns and removed cron entry"
}

while getopts "h?d:t:" opt; do
  case $opt in
    d) DOMAIN=$OPTARG ;;
    t) TOKEN=$OPTARG ;;
    h|\?)
      echo "Syntax: ./dynamic-dns-duck-dns.sh -d <domain> -t <token>" >&2
      exit 1
      ;;
  esac
done

# Create a new isolated directory & update script
mkdir -p "$HOME/.duckdns"
touch "$HOME/.duckdns/update.sh"
echo "echo url=\"https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=\" | curl -k -o $HOME/.duckdns/duck.log -K -" \
  > "$HOME/.duckdns/update.sh"
chmod 700 "$HOME/.duckdns/update.sh"

# Add the update script to the user's crontab
(crontab -l 2>/dev/null; echo "*/5 * * * * $HOME/.duckdns/update.sh >/dev/null 2>&1") | crontab -

# Perform a domain & token check
sh "$HOME/.duckdns/update.sh"
# shellcheck disable=SC2002
cat "$HOME/.duckdns/duck.log" | grep "KO" > nul && \
  (echo "Domain and/or token invalid. Please check $HOME/.duckdns/update.sh" && uninstall_duck_dns && exit 1)

# Restart the cron service
sudo systemctl restart cron

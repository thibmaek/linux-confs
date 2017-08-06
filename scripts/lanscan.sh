#!/usr/bin/env bash

if [[ -z $1 ]]; then
  echo "No domain given. Specify gateway address to scan from: e.g 192.168.1.1/24"
fi

nmap "$1" -n -sP | grep report | awk '{print $5}'

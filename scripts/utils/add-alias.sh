#!/usr/bin/env bash

# ▲ Adds a new alias to .aliases.

# @arg1: Alias name
# @arg2: Aliased command
if [ -z "$1" ] && [ -z "$2" ]; then
  echo "[WARN]: Incorrect params specified"
  echo "Usage: ./add-alias.sh rel \"exec \${SHELL} -l\""
  echo "Output: alias rel=\"exec \${SHELL} -l\""
  exit 1
fi

echo "alias $1=\"$2\"" >> .aliases && rel

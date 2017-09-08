#! /usr/bin/env bash

# ▲ Installs multiple packages from a txt file
#   much like requirements.txt & Gemfile

# @arg: Text file with listed packages.
#       For example: packages.txt
xargs -a $1 sudo apt install
